#!/usr/local/bin/bash

unset CHECKS_EXIT_CODE
unset CHECKS_STDOUT
unset CHECKS_STDERR

while [[ $# -gt 0 ]]; do
 if [[ $# -lt 2 ]]; then
  echo 'Wrong flags!' >&2; exit 1; fi
 case "$1" in
  '--exit_code'|'-c')
   if [[ -v CHECKS_EXIT_CODE ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   CHECKS_EXIT_CODE="$2"; shift 2;;
  '--stdout'|'-o')
   if [[ -v CHECKS_STDOUT ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   CHECKS_STDOUT="$2"; shift 2;;
  '--stderr'|'-e')
   if [[ -v CHECKS_STDERR ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   CHECKS_STDERR="$2"; shift 2;;
  *) echo "\"$1\" is not supported!" >&2; exit 1;;
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

if [[ -v CHECKS_STDOUT ]]; then
 if [[ -z "${CHECKS_STDOUT}" ]]; then
  echo 'No stdout!' >&2; exit 1; fi
 printf '%s\n' "${CHECKS_STDOUT}"
elif [[ -v CHECKS_STDERR ]]; then
 if [[ -z "${CHECKS_STDERR}" ]]; then
  echo 'No stderr!' >&2; exit 1; fi
 printf '%s\n' "${CHECKS_STDERR}" >&2
fi

exit "${CHECKS_EXIT_CODE}"
