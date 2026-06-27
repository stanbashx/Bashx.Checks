#!/usr/local/bin/bash

CHECKS_MESSAGE="$3"

if [[ $# -eq 3 ]]; then
 if [[ -z "${CHECKS_MESSAGE}" ]]; then
  echo 'No message!' >&2; exit 1; fi
elif [[ $# -ne 2 ]]; then
 echo 'Wrong arguments!' >&2; exit 1
fi

CHECKS_ACTUAL="$1"
CHECKS_EXPECTED="$2"

if [[ "${CHECKS_ACTUAL}" != "${CHECKS_EXPECTED}" ]]; then
 [[ -n "${CHECKS_MESSAGE}" ]] && echo "${CHECKS_MESSAGE}" >&2
 exit 1
fi
