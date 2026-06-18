#!/usr/local/bin/bash

SCRIPT='src/main/bash/strings/eq.sh'

echo "Running test for \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has invalid syntax!" >&2; exit 1; fi

STDOUT="$(mktemp)"
STDERR="$(mktemp)"

#

"${SCRIPT}" >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"

"${SCRIPT}" '' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"

"${SCRIPT}" '' '' '' '' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"

"${SCRIPT}" 'a' 'a' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"

"${SCRIPT}" 'a' 'b' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"

"${SCRIPT}" 'a' 'a' 'c' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"

"${SCRIPT}" 'a' 'b' 'c' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'c\n'

"${SCRIPT}" 'a' 'b' '' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No message!\n'

echo 'Not implemented!'; exit 1 # todo

"${SCRIPT}" '' '' '' 2>"${STDERR}"; CODE=$?
. $asserts/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'No message!'

:> "${STDERR}"

"${SCRIPT}" 'a' 'b' 'c' 2>"${STDERR}"; CODE=$?
. $asserts/eq.sh "${SCRIPT}" "${CODE}" '1'
. $asserts/eq.sh "${SCRIPT}" "$(<"${STDERR}")" 'c'

:> "${STDERR}"

"${SCRIPT}" 'a' 'a' 'c' 2>"${STDERR}"; CODE=$?
. $asserts/eq.sh "${SCRIPT}" "${CODE}" '0'
. $asserts/empty.sh "${SCRIPT}" "$(<"${STDERR}")"

#

rm "${STDOUT}"
rm "${STDERR}"
