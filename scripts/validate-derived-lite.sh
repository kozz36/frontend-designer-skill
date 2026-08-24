#!/usr/bin/env bash
# Validates the immutable v3.0.1 full-to-lite derivation inventory and byte-level outputs.
# shellcheck disable=SC2034 # Arrays are passed dynamically to assert_exact_set via local -n.
set -euo pipefail

readonly EXPECTED_VERSION="3.0.1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
readonly SCRIPT_DIR
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd -P)"
readonly REPO_ROOT
readonly MANIFEST="${REPO_ROOT}/docs/derivation/frontend-designer-lite-v3.0.1.manifest.tsv"
readonly COVERAGE="${REPO_ROOT}/docs/derivation/frontend-designer-lite-v3.0.1.coverage.tsv"
readonly FULL_RUNTIME="skills/frontend-designer/SKILL.md"
readonly FULL_REFERENCE="skills/frontend-designer/references/technical-reference.md"
readonly FULL_INDEX="skills/frontend-designer/references/source-index.md"
readonly LITE_RUNTIME="skills/frontend-designer-lite/SKILL.md"
readonly FULL_ARCHIVE="versions/v3.0.1/ARCHIVE.md"
readonly LITE_ARCHIVE="versions/v3.0.1-lite/ARCHIVE.md"

fail() {
  printf 'validate-derived-lite: %s\n' "$*" >&2
  return 1
}

require_file() {
  [[ -f "$1" ]] || fail "missing required file: ${1#"${REPO_ROOT}/"}"
}

assert_exact_set() {
  local label="$1"
  local -n expected_ref="$2"
  local -n actual_ref="$3"
  local item
  local -A expected_seen=()
  local -A actual_seen=()

  for item in "${expected_ref[@]}"; do
    if [[ -z "$item" ]]; then
      fail "${label}: expected set contains an empty entry"
      return 1
    fi
    if [[ -n "${expected_seen[$item]+x}" ]]; then
      fail "${label}: duplicate expected entry: ${item}"
      return 1
    fi
    expected_seen["$item"]=1
  done

  for item in "${actual_ref[@]}"; do
    if [[ -z "$item" ]]; then
      fail "${label}: actual set contains an empty entry"
      return 1
    fi
    if [[ -n "${actual_seen[$item]+x}" ]]; then
      fail "${label}: duplicate entry: ${item}"
      return 1
    fi
    actual_seen["$item"]=1
  done

  for item in "${!expected_seen[@]}"; do
    if [[ -z "${actual_seen[$item]+x}" ]]; then
      fail "${label}: missing entry: ${item}"
      return 1
    fi
  done

  for item in "${!actual_seen[@]}"; do
    if [[ -z "${expected_seen[$item]+x}" ]]; then
      fail "${label}: extra or renamed entry: ${item}"
      return 1
    fi
  done
}

manifest_hash_for() {
  local record="$1"
  local path="$2"
  local -a hashes=()

  mapfile -t hashes < <(awk -F '\t' -v record="$record" -v path="$path" \
    '$1 == record && $2 == path { print $3 }' "$MANIFEST")
  if [[ "${#hashes[@]}" -ne 1 ]]; then
    fail "manifest requires exactly one ${record} record for ${path}"
    return 1
  fi
  printf '%s\n' "${hashes[0]}"
}

assert_manifest_hash() {
  local record="$1"
  local path="$2"
  local expected_hash
  local actual_hash

  require_file "${REPO_ROOT}/${path}"
  expected_hash="$(manifest_hash_for "$record" "$path")"
  actual_hash="$(sha256sum "${REPO_ROOT}/${path}" | awk '{print $1}')"
  if [[ "$actual_hash" != "$expected_hash" ]]; then
    fail "${path}: hash differs from immutable ${record} record"
    return 1
  fi
}

metadata_version() {
  local path="$1"
  local -a versions=()

  mapfile -t versions < <(awk '
    /^metadata:[[:space:]]*$/ { in_metadata = 1; next }
    in_metadata && /^  version: "[^"]+"[[:space:]]*$/ {
      value = $0
      sub(/^  version: "/, "", value)
      sub(/"[[:space:]]*$/, "", value)
      print value
    }
  ' "$path")
  if [[ "${#versions[@]}" -ne 1 ]]; then
    fail "${path#"${REPO_ROOT}/"}: metadata must contain one version"
    return 1
  fi
  printf '%s\n' "${versions[0]}"
}

assert_version() {
  local path="$1"
  local actual_version

  actual_version="$(metadata_version "${REPO_ROOT}/${path}")"
  if [[ "$actual_version" != "$EXPECTED_VERSION" ]]; then
    fail "${path}: expected version ${EXPECTED_VERSION}, found ${actual_version}"
    return 1
  fi
}

assert_same_bytes() {
  local first="$1"
  local second="$2"

  cmp -s "${REPO_ROOT}/${first}" "${REPO_ROOT}/${second}" || \
    fail "byte parity failed: ${first} != ${second}"
}

assert_anchor() {
  local path="$1"
  local anchor="$2"

  grep -Fq -- "$anchor" "${REPO_ROOT}/${path}" || \
    fail "missing coverage anchor in ${path}: ${anchor}"
}

validate_manifest() {
  local -a expected_sources=("$FULL_RUNTIME" "$FULL_REFERENCE" "$FULL_INDEX")
  local -a actual_sources=()
  local -a expected_generated=("$LITE_RUNTIME")
  local -a actual_generated=()
  local -a expected_forbidden=("versions/" "$LITE_RUNTIME")
  local -a actual_forbidden=()
  local -a expected_omissions=(
    "Detailed rationale"
    "Examples and snippets"
    "Exhaustive decision tables"
    "Repeated source links"
    "Privacy-specific runtime policy"
  )
  local -a actual_omissions=()
  local path

  require_file "$MANIFEST"
  awk -F '\t' '
    $0 !~ /^#/ && NF > 0 && NF != 4 { exit 1 }
  ' "$MANIFEST" || fail "manifest must have exactly four tab-separated columns"

  while IFS=$'\t' read -r path _ _; do
    actual_sources+=("$path")
    [[ "$path" != versions/* ]] || fail "archive path is forbidden as a SOURCE: ${path}"
    [[ "$path" != "$LITE_RUNTIME" ]] || fail "prior lite runtime is forbidden as a SOURCE"
  done < <(awk -F '\t' '$1 == "SOURCE" { print $2 "\t" $3 "\t" $4 }' "$MANIFEST")
  assert_exact_set "manifest SOURCE inventory" expected_sources actual_sources

  while IFS=$'\t' read -r path _ _; do
    actual_generated+=("$path")
  done < <(awk -F '\t' '$1 == "GENERATED" { print $2 "\t" $3 "\t" $4 }' "$MANIFEST")
  assert_exact_set "manifest GENERATED inventory" expected_generated actual_generated

  while IFS=$'\t' read -r path _ _; do
    actual_forbidden+=("$path")
  done < <(awk -F '\t' '$1 == "FORBIDDEN" { print $2 "\t" $3 "\t" $4 }' "$MANIFEST")
  assert_exact_set "manifest FORBIDDEN inventory" expected_forbidden actual_forbidden

  while IFS=$'\t' read -r path _ _; do
    actual_omissions+=("$path")
  done < <(awk -F '\t' '$1 == "OMISSION" { print $2 "\t" $3 "\t" $4 }' "$MANIFEST")
  assert_exact_set "manifest omission inventory" expected_omissions actual_omissions

  grep -Fqx $'DERIVATION\tfull-runtime+technical-reference+source-index\t-\tCompact only the three exact SOURCE records; no prior lite or archive content is an input.' "$MANIFEST" || \
    fail "manifest must declare the only permitted derivation inputs"
  grep -Fqx $'DISCLAIMER\tsemantic-proof\t-\tHash, anchor, inventory, and archive checks prove structural derivation evidence only; independent review is required for semantic proof.' "$MANIFEST" || \
    fail "manifest must retain the independent semantic-review disclaimer"

  for path in "${expected_sources[@]}"; do
    assert_manifest_hash "SOURCE" "$path"
  done
  assert_manifest_hash "GENERATED" "$LITE_RUNTIME"
  assert_manifest_hash "ARCHIVE" "$LITE_ARCHIVE"
}

validate_coverage() {
  local -a expected_invariants=(
    "ACT-001:activation" "ACT-002:exclusion" "RULE-001:token-state"
    "A11Y-001:accessibility" "PERF-001:performance" "VERIFY-001:live-verification"
    "GATE-001:repository-css" "GATE-002:design-source" "GATE-003:browser-api"
    "GATE-004:tokens-oklch" "GATE-005:themes" "GATE-006:layout"
    "GATE-007:accessibility" "GATE-008:performance" "GATE-009:tooling"
    "EXEC-001:inputs" "EXEC-002:contracts" "EXEC-003:alternatives"
    "EXEC-004:reference-use" "EXEC-005:validation" "OUT-001:pattern-evidence"
    "OUT-002:rejected-alternatives" "OUT-003:runtime-risks" "OUT-004:validation-output"
    "REF-001:conditional-use" "REF-002:decision-inputs" "REF-003:css-paradigm"
    "REF-004:tokens-oklch" "REF-005:components-layout" "REF-006:accessibility-motion"
    "REF-007:visual-performance" "REF-008:local-handoff" "REF-009:tooling"
    "SRC-001:live-verification" "SRC-002:claim-scope" "SRC-003:verification-record"
    "SRC-004:browser-source" "SRC-005:accessibility-law" "SEC-001:security-claims"
    "OMIT-001:examples" "OMIT-002:snippets" "OMIT-003:exhaustive-tables"
    "OMIT-004:repeated-links"
  )
  local -a actual_invariants=()
  local id category source_path full_anchor lite_anchor disposition

  require_file "$COVERAGE"
  awk -F '\t' '
    $0 !~ /^#/ && $0 !~ /^id\t/ && NF > 0 && NF != 6 { exit 1 }
  ' "$COVERAGE" || fail "coverage matrix must have exactly six tab-separated columns"

  while IFS=$'\t' read -r id category source_path full_anchor lite_anchor disposition; do
    [[ -z "$id" || "$id" == \#* || "$id" == "id" ]] && continue
    [[ -n "$category" && -n "$source_path" && -n "$full_anchor" && -n "$lite_anchor" && -n "$disposition" ]] || \
      fail "coverage invariant ${id}: all columns are required"
    actual_invariants+=("${id}:${category}")
    case "$source_path" in
      "$FULL_RUNTIME"|"$FULL_REFERENCE"|"$FULL_INDEX") ;;
      *) fail "coverage invariant ${id}: source is not an approved full-package input: ${source_path}" ;;
    esac
    assert_anchor "$source_path" "$full_anchor"
    case "$disposition" in
      compacted|integrated) assert_anchor "$LITE_RUNTIME" "$lite_anchor" ;;
      omitted) [[ "$lite_anchor" == "NOT_APPLICABLE" ]] || \
        fail "coverage invariant ${id}: omitted rows require NOT_APPLICABLE lite anchor" ;;
      *) fail "coverage invariant ${id}: unknown disposition ${disposition}" ;;
    esac
  done < "$COVERAGE"

  assert_exact_set "coverage invariant IDs/categories" expected_invariants actual_invariants
}

validate_install_surface() {
  local -a expected_full_files=(
    "skills/frontend-designer/SKILL.md"
    "skills/frontend-designer/references/technical-reference.md"
    "skills/frontend-designer/references/source-index.md"
  )
  local -a expected_lite_files=("skills/frontend-designer-lite/SKILL.md")
  local -a expected_skill_entrypoints=(
    "skills/frontend-designer/SKILL.md"
    "skills/frontend-designer-lite/SKILL.md"
  )
  local -a actual_full_files=()
  local -a actual_lite_files=()
  local -a actual_skill_entrypoints=()
  local -a archive_skill_entrypoints=()
  local path

  mapfile -t actual_full_files < <(cd "$REPO_ROOT" && find skills/frontend-designer -type f -print | LC_ALL=C sort)
  mapfile -t actual_lite_files < <(cd "$REPO_ROOT" && find skills/frontend-designer-lite -type f -print | LC_ALL=C sort)
  mapfile -t actual_skill_entrypoints < <(cd "$REPO_ROOT" && find skills -type f -name SKILL.md -print | LC_ALL=C sort)
  mapfile -t archive_skill_entrypoints < <(find "${REPO_ROOT}/versions" -type f -name SKILL.md -print)

  assert_exact_set "full install file inventory" expected_full_files actual_full_files
  assert_exact_set "lite install file inventory" expected_lite_files actual_lite_files
  assert_exact_set "discoverable SKILL.md inventory" expected_skill_entrypoints actual_skill_entrypoints
  [[ "${#archive_skill_entrypoints[@]}" -eq 0 ]] || fail "archive contains discoverable SKILL.md entrypoint: ${archive_skill_entrypoints[*]}"

  for path in "$FULL_RUNTIME" "$LITE_RUNTIME" "$FULL_ARCHIVE" "$LITE_ARCHIVE"; do
    assert_version "$path"
  done

  assert_same_bytes "$FULL_RUNTIME" "$FULL_ARCHIVE"
  assert_same_bytes "$FULL_REFERENCE" "versions/v3.0.1/references/technical-reference.md"
  assert_same_bytes "$FULL_INDEX" "versions/v3.0.1/references/source-index.md"
  assert_same_bytes "$LITE_RUNTIME" "$LITE_ARCHIVE"

  if grep -Fq -- "versions/" "${REPO_ROOT}/${LITE_RUNTIME}"; then
    fail "lite runtime must not reference archive paths"
  fi
  if grep -Fq -- "ARCHIVE.md" "${REPO_ROOT}/${LITE_RUNTIME}"; then
    fail "lite runtime must not reference archive entrypoints"
  fi
}

run_self_tests() {
  local -a expected_generated=("$LITE_RUNTIME")
  local -a correct_generated=("$LITE_RUNTIME")
  local -a missing_generated=()
  local -a duplicate_generated=("$LITE_RUNTIME" "$LITE_RUNTIME")
  local -a extra_generated=("$LITE_RUNTIME" "skills/unexpected/SKILL.md")
  local -a renamed_generated=("skills/frontend-designer-lite/RENAMED-SKILL.md")

  assert_exact_set "self-test GENERATED correct" expected_generated correct_generated
  if assert_exact_set "self-test GENERATED missing" expected_generated missing_generated >/dev/null 2>&1; then
    fail "self-test GENERATED missing case unexpectedly passed"
  fi
  if assert_exact_set "self-test GENERATED duplicate" expected_generated duplicate_generated >/dev/null 2>&1; then
    fail "self-test GENERATED duplicate case unexpectedly passed"
  fi
  if assert_exact_set "self-test GENERATED extra" expected_generated extra_generated >/dev/null 2>&1; then
    fail "self-test GENERATED extra case unexpectedly passed"
  fi
  if assert_exact_set "self-test GENERATED renamed" expected_generated renamed_generated >/dev/null 2>&1; then
    fail "self-test GENERATED renamed case unexpectedly passed"
  fi
  printf 'validate-derived-lite: GENERATED missing/duplicate/extra/renamed self-tests passed\n'
}

usage() {
  printf 'Usage: %s [--self-test]\n' "${0##*/}" >&2
}

main() {
  case "${1:-}" in
    "")
      validate_manifest
      validate_coverage
      validate_install_surface
      printf 'validate-derived-lite: v%s derivation, archive, install, and coverage checks passed\n' "$EXPECTED_VERSION"
      ;;
    --self-test)
      [[ "$#" -eq 1 ]] || { usage; return 2; }
      run_self_tests
      ;;
    *)
      usage
      return 2
      ;;
  esac
}

main "$@"
