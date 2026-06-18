#!/usr/local/bin/bash

SCRIPT='src/main/bash/strings/require.sh'

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
. $asserts/files/equals.sh "${STDERR}" $'No arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"
ASSERTS_FOO='' "${SCRIPT}" ASSERTS_FOO >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Argument "ASSERTS_FOO" is empty!\n'

:> "${STDOUT}"
:> "${STDERR}"
ASSERTS_FOO='1' "${SCRIPT}" ASSERTS_FOO >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"
ASSERTS_FOO='' ASSERTS_BAR='2' ASSERTS_BAZ='3' "${SCRIPT}" ASSERTS_FOO ASSERTS_BAR ASSERTS_BAZ >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Argument "ASSERTS_FOO" is empty!\n'

:> "${STDOUT}"
:> "${STDERR}"
ASSERTS_FOO='1' ASSERTS_BAR='' ASSERTS_BAZ='3' "${SCRIPT}" ASSERTS_FOO ASSERTS_BAR ASSERTS_BAZ >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Argument "ASSERTS_BAR" is empty!\n'

:> "${STDOUT}"
:> "${STDERR}"
ASSERTS_FOO='1' ASSERTS_BAR='2' ASSERTS_BAZ='' "${SCRIPT}" ASSERTS_FOO ASSERTS_BAR ASSERTS_BAZ >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Argument "ASSERTS_BAZ" is empty!\n'

:> "${STDOUT}"
:> "${STDERR}"
ASSERTS_FOO='1' ASSERTS_BAR='2' ASSERTS_BAZ='3' "${SCRIPT}" '' ASSERTS_BAR ASSERTS_BAZ >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Argument 1/3 name is empty!\n'

:> "${STDOUT}"
:> "${STDERR}"
ASSERTS_FOO='1' ASSERTS_BAR='2' ASSERTS_BAZ='3' "${SCRIPT}" ASSERTS_FOO '' ASSERTS_BAZ >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Argument 2/3 name is empty!\n'

:> "${STDOUT}"
:> "${STDERR}"
ASSERTS_FOO='1' ASSERTS_BAR='2' ASSERTS_BAZ='3' "${SCRIPT}" ASSERTS_FOO ASSERTS_BAR '' >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Argument 3/3 name is empty!\n'

:> "${STDOUT}"
:> "${STDERR}"
ASSERTS_FOO='1' ASSERTS_BAR='2' ASSERTS_BAZ='3' "${SCRIPT}" ASSERTS_FOO ASSERTS_BAR ASSERTS_BAZ >"${STDOUT}" 2>"${STDERR}"
. $asserts/strings/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

#

rm "${STDOUT}"
rm "${STDERR}"
