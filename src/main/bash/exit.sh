#!/usr/local/bin/bash

unset CHECKS_EXIT_CODE
unset CHECKS_MESSAGE

while [[ $# -gt 0 ]]; do
 if [[ $# -lt 2 ]]; then
  echo 'Wrong flags!' >&2; exit 1; fi
 case "$1" in
  '--exit_code'|'-e')
   if [[ -v CHECKS_EXIT_CODE ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   CHECKS_EXIT_CODE="$2"; shift 2;;
  '--message'|'-m')
   if [[ -v CHECKS_MESSAGE ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   CHECKS_MESSAGE="$2"; shift 2;;
 esac
done

if [[ -v CHECKS_EXIT_CODE ]]; then
 if [[ -z "${CHECKS_EXIT_CODE}" ]]; then
  echo 'No exit code!' >&2; exit 1
 elif [[ ! "${CHECKS_EXIT_CODE}" =~ ^(0|[1-9][0-9]{0,2})$ || "${CHECKS_EXIT_CODE}" -ge 256 ]]; then
  echo 'Wrong exit code!' >&2; exit 1
 fi
else
 CHECKS_EXIT_CODE=0
fi

if [[ -z "${CHECKS_MESSAGE}" ]]; then
 echo 'No message!' >&2; exit 1; fi

echo "${CHECKS_MESSAGE}"

exit "${CHECKS_EXIT_CODE}"
