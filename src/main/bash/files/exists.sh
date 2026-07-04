#!/usr/local/bin/bash

if [[ $# -ne 1 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

CHECKS_PATH="$1"

if [[ -z "${CHECKS_PATH}" ]]; then
 echo 'No path!' >&2; exit 1
elif [[ -L "${CHECKS_PATH}" ]]; then
 echo "\"${CHECKS_PATH}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${CHECKS_PATH}" ]]; then
 echo "\"${CHECKS_PATH}\" does not exist!" >&2; exit 1
elif [[ ! -f "${CHECKS_PATH}" ]]; then
 echo "\"${CHECKS_PATH}\" is not a file!" >&2; exit 1
fi
