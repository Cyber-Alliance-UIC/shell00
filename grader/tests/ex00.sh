#!/bin/sh
# ex00.sh — checks starter/ex00/whoareyou.sh
#
# Sourced by run.sh, which has already loaded lib/colors.sh, lib/assert.sh,
# lib/utils.sh and cd'd into the repo root. This script must define a
# function called check_ex00 and nothing else at the top level (no direct
# execution), so run.sh can call it in an isolated subshell per exercise.

check_ex00() {
    checker_header "ex00 — whoareyou"

    script="starter/ex00/whoareyou.sh"

    assert_file_exists "$script" "whoareyou.sh exists"
    assert_executable  "$script" "whoareyou.sh is executable"
    assert_shebang     "$script" "#!/bin/sh" "whoareyou.sh has #!/bin/sh shebang"

    if [ ! -x "$script" ]; then
        summary
        return $?
    fi

    expected_user="${USER:-$(whoami)}"
    run_capture "$script"

    assert_exit_code "$RUN_EXIT" 0 "exits with status 0"
    assert_eq "$RUN_STDOUT" "Hello, I am ${expected_user}!" "prints the correct greeting"
    assert_no_stderr "$RUN_STDERR" "produces no stderr output"

    summary
}
