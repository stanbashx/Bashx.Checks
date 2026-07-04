#!/usr/local/bin/bash

SCRIPT='src/main/bash/files/execs.sh'

echo "Running test for \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has invalid syntax!" >&2; exit 1; fi

STDOUT="$(mktemp)"
STDERR="$(mktemp)"

#

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH=''
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No path!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
rm "${CHECKS_PATH}"
ln -s "${CHECKS_PATH}" "${CHECKS_PATH}"
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is a symlink!"$'\n'
rm "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
rm "${CHECKS_PATH}"
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" does not exist!"$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp -d)"
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is not a file!"$'\n'
rm -r "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is empty!"$'\n'
rm "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
printf '%s' 'foo' > "${CHECKS_PATH}"
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is not executable!"$'\n'
rm "${CHECKS_PATH}"

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
printf '%s' 'foo' > "${CHECKS_PATH}"
chmod +x "${CHECKS_PATH}"
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"
rm "${CHECKS_PATH}"

#

rm "${STDOUT}"
rm "${STDERR}"
