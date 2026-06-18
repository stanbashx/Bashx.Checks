#!/usr/local/bin/bash

if [[ $# -lt 2 || $# -gt 3 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

CHECKS_ACTUAL="$1"
CHECKS_EXPECTED="$2"

if [[ "${CHECKS_ACTUAL}" != "${CHECKS_EXPECTED}" ]]; then
 if [[ $# -eq 3 ]]; then
  CHECKS_MESSAGE="$3"
  if [[ -z "${CHECKS_MESSAGE}" ]]; then
   echo 'No message!' >&2; exit 1; fi
  echo "${CHECKS_MESSAGE}" >&2
 fi
 exit 1
fi
