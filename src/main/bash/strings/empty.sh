#!/usr/local/bin/bash

CHECKS_MESSAGE="$2"

if [[ $# -eq 2 ]]; then
 if [[ -z "${CHECKS_MESSAGE}" ]]; then
  echo 'No message!' >&2; exit 1; fi
elif [[ $# -ne 1 ]]; then
 echo 'Wrong arguments!' >&2; exit 1
fi

if [[ -n "$1" ]]; then
 [[ -n "${CHECKS_MESSAGE}" ]] && echo "${CHECKS_MESSAGE}" >&2
 exit 1
fi
