#!/bin/sh

if [ "$#" -ne 2 ]; then
    echo "Error" >&2
    exit 1
fi

if [ "$2" -eq 0 ]; then
    echo "Error" >&2
    exit 1
fi

printf '%s\n' "$(( $1 / $2 ))"
