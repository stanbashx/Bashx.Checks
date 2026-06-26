#!/usr/local/bin/bash

if [[ $# -eq 1 ]]; then
 CHECKS_MESSAGE="$1"
 if [[ -z "${CHECKS_MESSAGE}" ]]; then
  echo 'No message!' >&2; exit 1; fi
 echo "${CHECKS_MESSAGE}" >&2
elif [[ $# -gt 1 ]]; then
 echo 'Wrong arguments!' >&2; exit 1
fi

exit 1
