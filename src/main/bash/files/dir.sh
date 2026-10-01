#!/usr/local/bin/bash

unset CHECKS_PATH

while [[ $# -gt 0 ]]; do
 if [[ $# -lt 2 ]]; then
  echo 'Wrong flags!' >&2; exit 1; fi
 case "$1" in
  '--path'|'-p')
   if [[ -v CHECKS_PATH ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   CHECKS_PATH="$2"; shift 2;;
  *) echo "\"$1\" is not supported!" >&2; exit 1;;
 esac
done

if [[ -z "${CHECKS_PATH}" ]]; then
 echo 'No path!' >&2; exit 1
elif [[ -L "${CHECKS_PATH}" ]]; then
 echo "\"${CHECKS_PATH}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${CHECKS_PATH}" ]]; then
 echo "\"${CHECKS_PATH}\" does not exist!" >&2; exit 1
elif [[ ! -d "${CHECKS_PATH}" ]]; then
 echo "\"${CHECKS_PATH}\" is not a dir!" >&2; exit 1
fi
