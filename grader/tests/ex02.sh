#!/bin/sh
# ex02.sh — checks starter/ex02/safe_div.sh

check_ex02() {
    checker_header "ex02 — safe_div"

    script="starter/ex02/safe_div.sh"

    assert_file_exists "$script" "safe_div.sh exists"
    assert_executable  "$script" "safe_div.sh is executable"
    assert_shebang     "$script" "#!/bin/sh" "safe_div.sh has #!/bin/sh shebang"

    if [ ! -x "$script" ]; then
        summary
        return $?
    fi

    # Normal division
    run_capture "$script" 10 2
    assert_exit_code "$RUN_EXIT" 0 "10 / 2 exits 0"
    assert_eq "$RUN_STDOUT" "5" "10 / 2 == 5"

    # Integer truncation
    run_capture "$script" 7 2
    assert_eq "$RUN_STDOUT" "3" "7 / 2 truncates to 3"

    # Division by zero
    run_capture "$script" 10 0
    assert_exit_code "$RUN_EXIT" 1 "division by zero exits 1"
    assert_true "$( [ -n "$RUN_STDERR" ] && echo 0 || echo 1 )" "division by zero writes to stderr"

    # Wrong argument count
    run_capture "$script" 10
    assert_exit_code "$RUN_EXIT" 1 "missing argument exits 1"

    run_capture "$script" 10 2 3
    assert_exit_code "$RUN_EXIT" 1 "too many arguments exits 1"

    # Negative numbers (edge case)
    run_capture "$script" -10 2
    assert_eq "$RUN_STDOUT" "-5" "-10 / 2 == -5"

    summary
}
