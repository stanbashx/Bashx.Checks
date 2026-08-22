#!/usr/local/bin/bash

if [[ $# -lt 4 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

CHECKS_ACTUAL="$1"

if [[ -z "${CHECKS_ACTUAL}" ]]; then
 echo 'No actual!' >&2; exit 1; fi

CHECKS_MESSAGE="${!#}"

if [[ -z "${CHECKS_MESSAGE}" ]]; then
 echo 'No message!' >&2; exit 1; fi

for ((CHECKS_NUMBER=2; CHECKS_NUMBER<$#; CHECKS_NUMBER++)); do
 CHECKS_ARGUMENT="${!CHECKS_NUMBER}"
 if [[ -z "${CHECKS_ARGUMENT}" ]]; then
  echo "Argument $((CHECKS_NUMBER - 1))/$(($# - 2)) is empty!" >&2; exit 1; fi
done

CHECKS_FOUND=0
for ((CHECKS_NUMBER=2; CHECKS_NUMBER<$#; CHECKS_NUMBER++)); do
 CHECKS_ARGUMENT="${!CHECKS_NUMBER}"
 if [[ "${CHECKS_ACTUAL}" == "${CHECKS_ARGUMENT}" ]]; then
  CHECKS_FOUND="$((CHECKS_NUMBER - 1))"; break; fi
done

if [[ "${CHECKS_FOUND}" -lt 1 ]]; then
 printf '%s\n' "${CHECKS_MESSAGE}" >&2; exit 1; fi
