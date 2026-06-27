#!/usr/local/bin/bash

CHECKS_MESSAGE="$3"

if [[ $# -eq 3 ]]; then
 if [[ -z "${CHECKS_MESSAGE}" ]]; then
  echo 'No message!' >&2; exit 1; fi
elif [[ $# -ne 2 ]]; then
 echo 'Wrong arguments!' >&2; exit 1
fi

CHECKS_ACTUAL="$1"

if [[ -z "${CHECKS_ACTUAL}" ]]; then
 echo 'No actual!' >&2; exit 1
elif [[ ! "${CHECKS_ACTUAL}" =~ ^(0|-?[1-9][0-9]*)$ ]]; then
 echo "Actual(${#CHECKS_ACTUAL}): \"${CHECKS_ACTUAL}\" is not a number!" >&2; exit 1
elif ((CHECKS_ACTUAL < -2147483648 || CHECKS_ACTUAL > 2147483647)); then
 echo "Actual: ${CHECKS_ACTUAL} is not an int32!" >&2; exit 1
fi

CHECKS_EXPECTED="$2"

if [[ -z "${CHECKS_EXPECTED}" ]]; then
 echo 'No expected!' >&2; exit 1
elif [[ ! "${CHECKS_EXPECTED}" =~ ^(0|-?[1-9][0-9]*)$ ]]; then
 echo "Expected(${#CHECKS_EXPECTED}): \"${CHECKS_EXPECTED}\" is not a number!" >&2; exit 1
elif ((CHECKS_EXPECTED < -2147483648 || CHECKS_EXPECTED > 2147483647)); then
 echo "Expected: ${CHECKS_EXPECTED} is not an int32!" >&2; exit 1
fi

if [[ "${CHECKS_ACTUAL}" -eq "${CHECKS_EXPECTED}" ]]; then
 [[ -n "${CHECKS_MESSAGE}" ]] && echo "${CHECKS_MESSAGE}" >&2
 exit 1
fi
