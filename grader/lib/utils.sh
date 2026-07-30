#!/bin/sh
# utils.sh — shared helpers for running student scripts safely and
# capturing their stdout/stderr/exit code independently.
#
# Requires colors.sh to already be sourced.

# Default timeout (seconds) for any student-submitted script, to protect the
# grader from infinite loops / fork bombs / hangs.
DEFAULT_TIMEOUT="${DEFAULT_TIMEOUT:-5}"

# run_capture <script_path> [args...]
#
# Runs a student script with a timeout, capturing stdout and stderr into
# separate temp files, and exposes three variables to the caller:
#   RUN_STDOUT   - contents of stdout
#   RUN_STDERR   - contents of stderr
#   RUN_EXIT     - exit code (124 if it timed out)
#
# Temp files are cleaned up automatically on each call.
run_capture() {
    script="$1"
    shift

    _out=$(mktemp)
    _err=$(mktemp)

    if command -v timeout >/dev/null 2>&1; then
        timeout "$DEFAULT_TIMEOUT" "$script" "$@" >"$_out" 2>"$_err"
        RUN_EXIT=$?
    else
        # Fallback when `timeout` isn't available (rare on GH runners, but
        # keep the grader portable for local student machines).
        "$script" "$@" >"$_out" 2>"$_err"
        RUN_EXIT=$?
    fi

    RUN_STDOUT=$(cat "$_out")
    RUN_STDERR=$(cat "$_err")
    rm -f "$_out" "$_err"
}

# require_command <name>
# Aborts the whole grader run early with a clear message if a required
# system tool is missing (keeps failures readable instead of cryptic).
require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        fail "Required command not found on this system: $1"
        exit 1
    fi
}

# checker_header <exercise_name>
checker_header() {
    section "Grading: $1"
}
