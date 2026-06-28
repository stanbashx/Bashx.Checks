#!/usr/local/bin/bash

CHECKS_MESSAGE="$3"

if [[ $# -eq 3 ]]; then
 if [[ -z "${CHECKS_MESSAGE}" ]]; then
  echo 'No message!' >&2; exit 1; fi
elif [[ $# -ne 2 ]]; then
 echo 'Wrong arguments!' >&2; exit 1
fi

CHECKS_VAL="$1"

if [[ -z "${CHECKS_VAL}" ]]; then
 echo 'No value!' >&2; exit 1
elif [[ ! "${CHECKS_VAL}" =~ ^(0|-?[1-9][0-9]*)$ ]]; then
 echo "Value(${#CHECKS_VAL}): \"${CHECKS_VAL}\" is not a number!" >&2; exit 1
elif ((CHECKS_VAL < -2147483648 || CHECKS_VAL > 2147483647)); then
 echo "Value: ${CHECKS_VAL} is not an int32!" >&2; exit 1
fi

CHECKS_REF="$2"

if [[ -z "${CHECKS_REF}" ]]; then
 echo 'No reference!' >&2; exit 1
elif [[ ! "${CHECKS_REF}" =~ ^(0|-?[1-9][0-9]*)$ ]]; then
 echo "Reference(${#CHECKS_REF}): \"${CHECKS_REF}\" is not a number!" >&2; exit 1
elif ((CHECKS_REF < -2147483648 || CHECKS_REF > 2147483647)); then
 echo "Reference: ${CHECKS_REF} is not an int32!" >&2; exit 1
fi

if [[ "${CHECKS_VAL}" -ge "${CHECKS_REF}" ]]; then
 [[ -n "${CHECKS_MESSAGE}" ]] && echo "${CHECKS_MESSAGE}" >&2
 exit 1
fi
