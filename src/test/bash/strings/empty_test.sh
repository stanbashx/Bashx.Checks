#!/usr/local/bin/bash

SCRIPT='src/main/bash/strings/empty.sh'

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
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_TEXT=''
"${SCRIPT}" "${CHECKS_TEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_TEXT=''
CHECKS_MESSAGE='foo'
"${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

VALUES=('42' ' ' $'\t' $'\n')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_TEXT="${VALUE}"
 "${SCRIPT}" "${CHECKS_TEXT}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
done

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_TEXT='42'
CHECKS_MESSAGE='foo'
"${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "${CHECKS_MESSAGE}"$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_TEXT=''
CHECKS_MESSAGE=''
"${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No message!\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_TEXT='42'
CHECKS_MESSAGE=''
"${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No message!\n'

#

rm "${STDOUT}"
rm "${STDERR}"
