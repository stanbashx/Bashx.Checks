#!/usr/local/bin/bash

SCRIPT='src/main/bash/strings/regex.sh'

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
"${SCRIPT}" -m 1 -m 2 > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" '"-m" already used!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_MESSAGE=''
"${SCRIPT}" -m "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No message!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_REGEX=''
"${SCRIPT}" -r "${CHECKS_REGEX}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No regex!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_REGEX='f+'
"${SCRIPT}" -r "${CHECKS_REGEX}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No text!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_REGEX='f+'
CHECKS_TEXT='bar'
"${SCRIPT}" -r "${CHECKS_REGEX}" -t "${CHECKS_TEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_MESSAGE='error message'
CHECKS_REGEX='f+'
CHECKS_TEXT='bar'
"${SCRIPT}" -m "${CHECKS_MESSAGE}" -r "${CHECKS_REGEX}" -t "${CHECKS_TEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "${CHECKS_MESSAGE}"$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_REGEX='f+'
CHECKS_TEXT='foo'
"${SCRIPT}" -r "${CHECKS_REGEX}" -t "${CHECKS_TEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_MESSAGE='error message'
CHECKS_REGEX='f+'
CHECKS_TEXT='foo'
"${SCRIPT}" -m "${CHECKS_MESSAGE}" -r "${CHECKS_REGEX}" -t "${CHECKS_TEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '0'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

#

rm "${STDOUT}"
rm "${STDERR}"
