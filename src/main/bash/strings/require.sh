#!/usr/local/bin/bash

if [[ $# -eq 0 ]]; then
 echo 'No arguments!' >&2; exit 1; fi

for ((CHECKS_INDEX=1; CHECKS_INDEX<=$#; CHECKS_INDEX++)); do
 CHECKS_ARGUMENT="${!CHECKS_INDEX}"
 if [[ -z "${!CHECKS_ARGUMENT}" ]]; then
  echo "Argument \"${CHECKS_ARGUMENT}\" is empty!"; exit 1; fi
done
