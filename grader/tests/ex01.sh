#!/bin/sh
# ex01.sh — checks starter/ex01/count_args.sh

check_ex01() {
    checker_header "ex01 — count_args"

    script="starter/ex01/count_args.sh"

    assert_file_exists "$script" "count_args.sh exists"
    assert_executable  "$script" "count_args.sh is executable"
    assert_shebang     "$script" "#!/bin/sh" "count_args.sh has #!/bin/sh shebang"

    if [ ! -x "$script" ]; then
        summary
        return $?
    fi

    # Case 1: no arguments
    run_capture "$script"
    assert_eq "$RUN_STDOUT" "0 argument(s)" "0 args -> '0 argument(s)'"

    # Case 2: three arguments
    run_capture "$script" a b c
    assert_eq "$RUN_STDOUT" "3 argument(s)" "3 args -> '3 argument(s)'"

    # Case 3: one argument (edge case near the singular/plural boundary,
    # subject intentionally keeps "argument(s)" literal for both)
    run_capture "$script" only
    assert_eq "$RUN_STDOUT" "1 argument(s)" "1 arg -> '1 argument(s)'"

    # Case 4: args containing spaces should still count as single args
    run_capture "$script" "hello world" foo
    assert_eq "$RUN_STDOUT" "2 argument(s)" "quoted multi-word arg counts as one"

    summary
}
