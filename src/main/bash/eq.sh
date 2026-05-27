#!/usr/local/bin/bash

if [[ $# -ne 3 ]]; then
 echo 'Wrong arguments!' >&2; exit 1; fi

CHECKS_ACTUAL="$1"
CHECKS_EXPECTED="$2"
CHECKS_MESSAGE="$3"

if [[ -z "${CHECKS_MESSAGE}" ]]; then
 echo 'No message!' >&2; exit 1; fi

if [[ "${CHECKS_ACTUAL}" != "${CHECKS_EXPECTED}" ]]; then
 echo "${CHECKS_MESSAGE}" >&2; exit 1; fi
