#!/bin/sh
# run.sh — grader entry point.
#
# Runs every exercise checker independently (one failing exercise never
# blocks the others), prints a colored per-exercise breakdown, and a final
# scoreboard. Exits 0 only if every exercise fully passed, so CI can use the
# exit code directly to mark the run as failed/succeeded.
#
# Usage:
#   ./grader/run.sh            # run all exercises
#   ./grader/run.sh ex01       # run a single exercise

set -u

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# shellcheck source=lib/colors.sh
. "$SCRIPT_DIR/lib/colors.sh"
# shellcheck source=lib/assert.sh
. "$SCRIPT_DIR/lib/assert.sh"
# shellcheck source=lib/utils.sh
. "$SCRIPT_DIR/lib/utils.sh"

cd "$REPO_ROOT" || { fail "Cannot cd to repo root: $REPO_ROOT"; exit 1; }

# The attached Shell00 subject defines exactly three exercises.
OFFICIAL_EXERCISES="ex00 ex01 ex02"

if [ "$#" -gt 0 ]; then
    REQUESTED_EXERCISES="$*"
else
    REQUESTED_EXERCISES="$OFFICIAL_EXERCISES"
fi

printf "%b%b" "$C_BOLD" "$C_MAGENTA"
cat << 'BANNER'
   ____      _               _   _ _ _
  / ___|   _| |__   ___ _ __ / \ | | (_) __ _ _ __   ___ ___
 | |  | | | | '_ \ / _ \ '__/ _ \| | | |/ _` | '_ \ / __/ _ \
 | |__| |_| | |_) |  __/ | / ___ \ | | | (_| | | | | (_|  __/
  \____\__, |_.__/ \___|_|/_/   \_\|_|_|_\__,_|_| |_|\___\___|
       |___/                shell00 — automatic grader
BANNER
printf "%b\n" "$C_RESET"

OVERALL_PASS=0
OVERALL_TOTAL=0
FAILED_EXERCISES=""

for ex in $REQUESTED_EXERCISES; do
    test_file="$SCRIPT_DIR/tests/${ex}.sh"
    if [ ! -f "$test_file" ]; then
        warn "No checker found for '$ex', skipping."
        continue
    fi

    # Run each exercise's checker in its own subshell so that TOTAL_CHECKS /
    # PASSED_CHECKS counters (and any stray `exit`) never leak between
    # exercises.
    (
        . "$test_file"
        check_fn="check_${ex}"
        if ! command -v "$check_fn" >/dev/null 2>&1; then
            fail "Checker file $test_file did not define $check_fn()"
            exit 1
        fi
        "$check_fn"
    )
    ex_status=$?

    # Re-derive per-exercise counts by re-sourcing is wasteful; instead we
    # rely on the subshell's own summary() output for detail and just track
    # pass/fail at the exercise level here.
    OVERALL_TOTAL=$((OVERALL_TOTAL + 1))
    if [ "$ex_status" -eq 0 ]; then
        OVERALL_PASS=$((OVERALL_PASS + 1))
    else
        FAILED_EXERCISES="$FAILED_EXERCISES $ex"
    fi
done

section "FINAL RESULT"
printf "Exercises passed: %b%d / %d%b\n" "$C_BOLD" "$OVERALL_PASS" "$OVERALL_TOTAL" "$C_RESET"

if [ -n "$FAILED_EXERCISES" ]; then
    printf "%bFailed:%b%s\n" "$C_RED" "$C_RESET" "$FAILED_EXERCISES"
    printf "\n%b%bFAIL%b\n" "$C_BOLD" "$C_RED" "$C_RESET"
    exit 1
fi

printf "\n%b%bPASS%b\n" "$C_BOLD" "$C_GREEN" "$C_RESET"
exit 0
