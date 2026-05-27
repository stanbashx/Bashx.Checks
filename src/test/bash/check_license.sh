#!/usr/local/bin/bash

ISSUER='LICENSE'
. $asserts/file/not/empty.sh "${ISSUER}"

AUTHOR='Stanley Wintergreen'
REGEX="Copyright 2[0-9]{3} ${AUTHOR}"

# todo asserts file regex

if ! grep -qE "${REGEX}" "${ISSUER}"; then
 echo "File \"${ISSUER}\" does not satisfy the regex:
---
${REGEX}
---"; exit 1; fi
