#!/usr/local/bin/bash

if [[ $# -eq 0 ]]; then
 echo 'No arguments!' >&2; exit 1; fi

for ((CHECKS_NUMBER=1; CHECKS_NUMBER<=$#; CHECKS_NUMBER++)); do
 CHECKS_ARGUMENT="${!CHECKS_NUMBER}"
 if [[ -z "${CHECKS_ARGUMENT}" ]]; then
  echo "Argument ${CHECKS_NUMBER}/$# is empty!" >&2; exit 1
 elif [[ ! "${CHECKS_ARGUMENT}" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]]; then
  echo "Argument ${CHECKS_NUMBER}/$# is wrong!" >&2; exit 1
 elif [[ ! -v "${CHECKS_ARGUMENT}" ]]; then
  echo "Variable \"${CHECKS_ARGUMENT}\" is unset!" >&2; exit 1
 elif [[ -z "${!CHECKS_ARGUMENT}" ]]; then
  echo "Variable \"${CHECKS_ARGUMENT}\" is empty!" >&2; exit 1
 fi
done
