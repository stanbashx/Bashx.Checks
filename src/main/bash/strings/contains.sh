#!/usr/local/bin/bash

CHECKS_MESSAGE="$3"

if [[ $# -eq 3 ]]; then
 if [[ -z "${CHECKS_MESSAGE}" ]]; then
  echo 'No message!' >&2; exit 1; fi
elif [[ $# -ne 2 ]]; then
 echo 'Wrong arguments!' >&2; exit 1
fi

CHECKS_TEXT="$1"
CHECKS_SUBTEXT="$2"

if [[ -z "${CHECKS_SUBTEXT}" ]]; then
 echo 'No subtext!' >&2; exit 1; fi

if [[ "${CHECKS_TEXT}" != *"${CHECKS_SUBTEXT}"* ]]; then
 [[ -n "${CHECKS_MESSAGE}" ]] && echo "${CHECKS_MESSAGE}" >&2
 exit 1
fi
