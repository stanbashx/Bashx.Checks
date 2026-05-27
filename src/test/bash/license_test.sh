#!/usr/local/bin/bash

ISSUER='LICENSE'
. $asserts/file/exists.sh "${ISSUER}"
# todo asserts is not empty
if [[ ! -s "${ISSUER}" ]]; then
 echo "File \"${ISSUER}\" is empty!"; exit 1; fi

AUTHOR='Stanley Wintergreen'
REGEX="Copyright 2[0-9]{3} ${AUTHOR}"

# todo asserts file regex

if ! grep -qE "${REGEX}" "${ISSUER}"; then
 echo "File \"${ISSUER}\" does not satisfy the regex:
---
${REGEX}
---"; exit 1; fi
