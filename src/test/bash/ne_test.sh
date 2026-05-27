#!/usr/local/bin/bash

SCRIPT="src/main/bash/ne.sh"

echo "Running test of \"${SCRIPT}\"..."

. $asserts/file/not/empty.sh "${SCRIPT}"

# todo asserts is executable

if [[ ! -x "${SCRIPT}" ]]; then
 echo "File \"${SCRIPT}\" is not executable!" >&2; exit 1; fi

# todo asserts script

STDERR="$(mktemp)"

"${SCRIPT}" 2>"${STDERR}"; CODE=$?
. $asserts/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

:> "${STDERR}"

"${SCRIPT}" '' 2>"${STDERR}"; CODE=$?
. $asserts/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

:> "${STDERR}"

"${SCRIPT}" '' '' 2>"${STDERR}"; CODE=$?
. $asserts/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

:> "${STDERR}"

"${SCRIPT}" '' '' '' '' 2>"${STDERR}"; CODE=$?
. $asserts/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'Wrong arguments!'

:> "${STDERR}"

"${SCRIPT}" '' '' '' 2>"${STDERR}"; CODE=$?
. $asserts/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No message!'

:> "${STDERR}"

"${SCRIPT}" 'a' 'a' 'c' 2>"${STDERR}"; CODE=$?
. $asserts/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'c'

:> "${STDERR}"

"${SCRIPT}" 'a' 'b' 'c' 2>"${STDERR}"; CODE=$?
. $asserts/eq.sh "${SCRIPT}" "${CODE}" '0'
. $asserts/empty.sh "${SCRIPT}" "$(<"${STDERR}")"

rm "${STDERR}"
