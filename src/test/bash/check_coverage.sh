#!/usr/local/bin/bash

scripts='src/main/bash'

SCRIPTS_COUNT=0
COVERED_COUNT=0

while IFS= read -r -d '' SCRIPT; do
 if [[ ! -e "${SCRIPT}" || -L "${SCRIPT}" ]]; then
  continue
 elif [[ ! -f "${SCRIPT}" || ! -x "${SCRIPT}" ]]; then
  continue
 elif [[ "${SCRIPT}" != *.sh ]]; then
  echo "Script \"${SCRIPT}\" is not supported!" >&2; exit 1
 fi
 SCRIPTS_COUNT=$((SCRIPTS_COUNT + 1))
 FILE_PATH="${SCRIPT#"${scripts}"/}"
 TEST_PATH="src/test/bash/${FILE_PATH/%.sh/_test.sh}"
 if [[ ! -e "${TEST_PATH}" || -L "${TEST_PATH}" || ! -f "${TEST_PATH}" || ! -x "${TEST_PATH}" ]]; then
  echo "Script \"${SCRIPT}\" is not covered!"; continue; fi
 COVERED_COUNT=$((COVERED_COUNT + 1))
done < <(find "${scripts}" -depth -type f -print0)

COVERED_RESULT=$((COVERED_COUNT * 100 / SCRIPTS_COUNT))

if [[ ${COVERED_RESULT} -lt 100 ]]; then
 echo "Only ${COVERED_RESULT}% of all scripts are covered!" >&2; exit 1
else
 echo 'All scripts are covered!'
fi
