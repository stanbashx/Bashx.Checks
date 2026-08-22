#!/usr/local/bin/bash

SCRIPT='src/main/bash/strings/any.sh'

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
"${SCRIPT}" '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL=''
"${SCRIPT}" "${CHECKS_ACTUAL}" '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No actual!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL='42'
CHECKS_MESSAGE=''
"${SCRIPT}" "${CHECKS_ACTUAL}" '' '' "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No message!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL='42'
CHECKS_MESSAGE='testmessage'
"${SCRIPT}" "${CHECKS_ACTUAL}" '' '' "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Argument 1/2 is empty!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL='42'
CHECKS_MESSAGE='testmessage'
"${SCRIPT}" "${CHECKS_ACTUAL}" 'foo' '' "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Argument 2/2 is empty!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL='42'
CHECKS_MESSAGE='testmessage'
"${SCRIPT}" "${CHECKS_ACTUAL}" 'foo' 'bar' "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "${CHECKS_MESSAGE}"$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL='42'
CHECKS_MESSAGE='testmessage'
"${SCRIPT}" "${CHECKS_ACTUAL}" '42' 'bar' "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL='42'
CHECKS_MESSAGE='testmessage'
"${SCRIPT}" "${CHECKS_ACTUAL}" 'foo' '42' "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL='42'
CHECKS_MESSAGE='testmessage'
"${SCRIPT}" "${CHECKS_ACTUAL}" '' '42' "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Argument 1/2 is empty!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL='42'
CHECKS_MESSAGE='testmessage'
"${SCRIPT}" "${CHECKS_ACTUAL}" '42' '' "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Argument 2/2 is empty!'$'\n'

#

rm "${STDOUT}"
rm "${STDERR}"
