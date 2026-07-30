# Subject: shell00 — Introduction to the Shell

## Foreword

This module introduces basic shell scripting: shebangs, permissions,
arguments, exit codes, and text processing. Each exercise lives in its own
folder under `starter/`.

## General rules

- All scripts must start with `#!/bin/sh` unless the exercise says otherwise.
- All scripts must be executable (`chmod +x`).
- Your script must not produce any output on `stderr` unless explicitly asked.
- Forbidden functions/tools will be listed per-exercise if applicable.

---

## Exercise 00 — `whoareyou`

**Turn-in directory:** `starter/ex00/`
**Files to turn in:** `whoareyou.sh`

Write a shell script that prints exactly:

```
Hello, I am <your_login>!
```

replacing `<your_login>` with the value of the `$USER` environment variable
(fall back to `whoami` if `$USER` is unset).

Example:

```console
$ ./whoareyou.sh
Hello, I am jdoe!
```

---

## Exercise 01 — `count_args`

**Turn-in directory:** `starter/ex01/`
**Files to turn in:** `count_args.sh`

Write a shell script that prints the number of arguments it was called with,
in the form:

```
<n> argument(s)
```

Examples:

```console
$ ./count_args.sh
0 argument(s)
$ ./count_args.sh a b c
3 argument(s)
```

---

## Exercise 02 — `safe_div`

**Turn-in directory:** `starter/ex02/`
**Files to turn in:** `safe_div.sh`

Write a shell script taking exactly two integer arguments `a` and `b` and
printing the integer division `a / b`.

- If the number of arguments is not exactly 2, print `Error` to stderr and
  exit with status `1`.
- If `b` is `0`, print `Error` to stderr and exit with status `1`.
- Otherwise print the result of `a / b` (integer division) followed by a
  newline, and exit with status `0`.

Examples:

```console
$ ./safe_div.sh 10 2
5
$ ./safe_div.sh 10 0
Error
$ echo $?
1
```
