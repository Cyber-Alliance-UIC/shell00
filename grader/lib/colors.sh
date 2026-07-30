#!/bin/sh
# colors.sh — ANSI color helpers shared by every checker.
#
# Usage:
#   . "$(dirname "$0")/lib/colors.sh"
#   printf "%bHello%b\n" "$C_GREEN" "$C_RESET"
#
# Colors are disabled automatically when stdout is not a TTY (e.g. some CI
# log viewers) unless FORCE_COLOR=1 is set, or when NO_COLOR is set
# (https://no-color.org).

if [ -n "${NO_COLOR:-}" ]; then
    _COLOR_ENABLED=0
elif [ -t 1 ] || [ "${FORCE_COLOR:-0}" = "1" ]; then
    _COLOR_ENABLED=1
else
    _COLOR_ENABLED=0
fi

if [ "$_COLOR_ENABLED" = "1" ]; then
    C_RESET='\033[0m'
    C_BOLD='\033[1m'
    C_DIM='\033[2m'
    C_RED='\033[31m'
    C_GREEN='\033[32m'
    C_YELLOW='\033[33m'
    C_BLUE='\033[34m'
    C_MAGENTA='\033[35m'
    C_CYAN='\033[36m'
else
    C_RESET=''
    C_BOLD=''
    C_DIM=''
    C_RED=''
    C_GREEN=''
    C_YELLOW=''
    C_BLUE=''
    C_MAGENTA=''
    C_CYAN=''
fi

# Semantic helpers -----------------------------------------------------------

info()  { printf "%b[INFO]%b %s\n"  "$C_BLUE"   "$C_RESET" "$1"; }
warn()  { printf "%b[WARN]%b %s\n"  "$C_YELLOW" "$C_RESET" "$1"; }
ok()    { printf "%b[ OK ]%b %s\n"  "$C_GREEN"  "$C_RESET" "$1"; }
fail()  { printf "%b[FAIL]%b %s\n"  "$C_RED"    "$C_RESET" "$1"; }

section() {
    printf "\n%b%b=== %s ===%b\n" "$C_BOLD" "$C_CYAN" "$1" "$C_RESET"
}
