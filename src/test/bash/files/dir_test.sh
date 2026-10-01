#!/usr/local/bin/bash

SCRIPT='src/main/bash/files/dir.sh'

echo "Running test for \"${SCRIPT}\"..."

. $asserts/files/execs.sh "${SCRIPT}"

if ! /usr/local/bin/bash -n "${SCRIPT}"; then
 echo "\"${SCRIPT}\" has invalid syntax!" >&2; exit 1; fi

STDOUT="$(mktemp)"
STDERR="$(mktemp)"

#

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" --foo > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong flags!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" --foo 1 > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" '"--foo" is not supported!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -p 1 -p 2 > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" '"-p" already used!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH=''
"${SCRIPT}" -p "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No path!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
rm "${CHECKS_PATH}"
ln -s "${CHECKS_PATH}" "${CHECKS_PATH}"
"${SCRIPT}" -p "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is a symlink!"$'\n'
rm "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
rm "${CHECKS_PATH}"
"${SCRIPT}" -p "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" does not exist!"$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
"${SCRIPT}" -p "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is not a dir!"$'\n'
rm "${CHECKS_PATH}"

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp -d)"
"${SCRIPT}" -p "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"
rm -r "${CHECKS_PATH}"

#

rm "${STDOUT}"
rm "${STDERR}"
