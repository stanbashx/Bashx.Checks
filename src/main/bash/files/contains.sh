#!/usr/local/bin/bash

CHECKS_MESSAGE="$3"

if [[ $# -eq 3 ]]; then
 if [[ -z "${CHECKS_MESSAGE}" ]]; then
  echo 'No message!' >&2; exit 1; fi
elif [[ $# -ne 2 ]]; then
 echo 'Wrong arguments!' >&2; exit 1
fi

CHECKS_PATH="$1"

if [[ -z "${CHECKS_PATH}" ]]; then
 echo 'No path!' >&2; exit 1
elif [[ -L "${CHECKS_PATH}" ]]; then
 echo "\"${CHECKS_PATH}\" is a symlink!" >&2; exit 1
elif [[ ! -e "${CHECKS_PATH}" ]]; then
 echo "\"${CHECKS_PATH}\" does not exist!" >&2; exit 1
elif [[ ! -f "${CHECKS_PATH}" ]]; then
 echo "\"${CHECKS_PATH}\" is not a file!" >&2; exit 1
elif [[ ! -s "${CHECKS_PATH}" ]]; then
 echo "\"${CHECKS_PATH}\" is empty!" >&2; exit 1
fi

CHECKS_SUBTEXT="$2"

if [[ -z "${CHECKS_SUBTEXT}" ]]; then
 echo 'No subtext!' >&2; exit 1; fi

rg -qU --fixed-strings -e "${CHECKS_SUBTEXT}" "${CHECKS_PATH}" 2>/dev/null; CODE=$?
if [[ "${CODE}" == '1' ]]; then
 [[ -n "${CHECKS_MESSAGE}" ]] && echo "${CHECKS_MESSAGE}" >&2
 exit 1
elif [[ "${CODE}" != '0' ]]; then
 echo "\"${CHECKS_PATH}\" read error!" >&2; exit 1
fi
