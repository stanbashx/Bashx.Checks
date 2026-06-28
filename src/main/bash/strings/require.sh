#!/usr/local/bin/bash

if [[ $# -eq 0 ]]; then
 echo 'No arguments!' >&2; exit 1; fi

for ((CHECKS_INDEX=1; CHECKS_INDEX<=$#; CHECKS_INDEX++)); do
 CHECKS_ARGUMENT="${!CHECKS_INDEX}"
 if [[ -z "${CHECKS_ARGUMENT}" ]]; then
  echo "Argument ${CHECKS_INDEX}/$# is empty!" >&2; exit 1
 elif [[ ! -v "${CHECKS_ARGUMENT}" ]]; then
  echo "Variable \"${CHECKS_ARGUMENT}\" is unset!" >&2; exit 1
 elif [[ -z "${!CHECKS_ARGUMENT}" ]]; then
  echo "Variable \"${CHECKS_ARGUMENT}\" is empty!" >&2; exit 1
 fi
done
