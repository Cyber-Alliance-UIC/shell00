#!/bin/sh
# assert.sh — reusable assertion primitives for exercise checkers.
#
# Every assert_* function:
#   - increments $TOTAL_CHECKS
#   - increments $PASSED_CHECKS on success
#   - prints a colored OK/FAIL line with a description
#   - returns 0 on success, 1 on failure (never exits the process)
#
# Requires colors.sh to already be sourced.

TOTAL_CHECKS=0
PASSED_CHECKS=0

_record() {
    # _record <0|1> <message>
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if [ "$1" = "0" ]; then
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
        ok "$2"
        return 0
    else
        fail "$2"
        return 1
    fi
}

# assert_eq <actual> <expected> <description>
assert_eq() {
    actual="$1"
    expected="$2"
    desc="${3:-values should match}"
    if [ "$actual" = "$expected" ]; then
        _record 0 "$desc"
    else
        _record 1 "$desc (expected: '$expected', got: '$actual')"
    fi
}

# assert_exit_code <actual_code> <expected_code> <description>
assert_exit_code() {
    actual="$1"
    expected="$2"
    desc="${3:-exit code should match}"
    if [ "$actual" -eq "$expected" ] 2>/dev/null; then
        _record 0 "$desc"
    else
        _record 1 "$desc (expected exit $expected, got $actual)"
    fi
}

# assert_file_exists <path> <description>
assert_file_exists() {
    path="$1"
    desc="${2:-$path should exist}"
    if [ -e "$path" ]; then
        _record 0 "$desc"
    else
        _record 1 "$desc (not found: $path)"
    fi
}

# assert_executable <path> <description>
assert_executable() {
    path="$1"
    desc="${2:-$path should be executable}"
    if [ -x "$path" ]; then
        _record 0 "$desc"
    else
        _record 1 "$desc (missing +x on: $path)"
    fi
}

# assert_shebang <path> <expected_shebang> <description>
assert_shebang() {
    path="$1"
    expected="$2"
    desc="${3:-$path should have shebang '$expected'}"
    actual=$(head -n1 "$path" 2>/dev/null)
    if [ "$actual" = "$expected" ]; then
        _record 0 "$desc"
    else
        _record 1 "$desc (got: '$actual')"
    fi
}

# assert_no_stderr <stderr_content> <description>
assert_no_stderr() {
    content="$1"
    desc="${2:-should not write to stderr}"
    if [ -z "$content" ]; then
        _record 0 "$desc"
    else
        _record 1 "$desc (stderr: '$content')"
    fi
}

# assert_true <condition_result_0_or_nonzero> <description>
# Pass the numeric result of a test, e.g.:  assert_true $?  "desc"
assert_true() {
    code="$1"
    desc="${2:-condition should be true}"
    if [ "$code" -eq 0 ] 2>/dev/null; then
        _record 0 "$desc"
    else
        _record 1 "$desc"
    fi
}

# summary — print a PASSED/FAILED count for the current exercise.
# Returns 0 if all checks passed, 1 otherwise. Call at the end of every
# exercise checker script.
summary() {
    printf "\n%b%d/%d checks passed%b\n" "$C_BOLD" "$PASSED_CHECKS" "$TOTAL_CHECKS" "$C_RESET"
    if [ "$PASSED_CHECKS" -eq "$TOTAL_CHECKS" ]; then
        return 0
    fi
    return 1
}
