#!/usr/local/bin/bash

unset CHECKS_MESSAGE
unset CHECKS_REGEX
unset CHECKS_TEXT

while [[ $# -gt 0 ]]; do
 if [[ $# -lt 2 ]]; then
  echo 'Wrong flags!' >&2; exit 1; fi
 case "$1" in
  '--message'|'-m')
   if [[ -v CHECKS_MESSAGE ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   CHECKS_MESSAGE="$2"; shift 2;;
  '--regex'|'-r')
   if [[ -v CHECKS_REGEX ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   CHECKS_REGEX="$2"; shift 2;;
  '--text'|'-t')
   if [[ -v CHECKS_TEXT ]]; then
    echo "\"$1\" already used!" >&2; exit 1; fi
   CHECKS_TEXT="$2"; shift 2;;
  *) echo "\"$1\" is not supported!" >&2; exit 1;;
 esac
done

if [[ -v CHECKS_MESSAGE ]]; then
 if [[ -z "${CHECKS_MESSAGE}" ]]; then
  echo 'No message!' >&2; exit 1; fi
fi

if [[ -z "${CHECKS_REGEX}" ]]; then
 echo 'No regex!' >&2; exit 1; fi

if [[ ! -v CHECKS_TEXT ]]; then
 echo 'No text!' >&2; exit 1; fi

[[ "${CHECKS_TEXT}" =~ ${CHECKS_REGEX} ]]; CODE=$?

if [[ "${CODE}" == '2' ]]; then
 echo "\"${CHECKS_REGEX}\" is invalid!" >&2; exit 1
elif [[ "${CODE}" != '0' ]]; then
 [[ -n "${CHECKS_MESSAGE}" ]] && printf '%s\n' "${CHECKS_MESSAGE}" >&2
 exit 1
fi
