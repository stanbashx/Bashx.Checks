#!/usr/local/bin/bash

SCRIPT='src/main/bash/ints/eq.sh'

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
"${SCRIPT}" '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" '' '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'Wrong arguments!\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL=''
CHECKS_EXPECTED=''
"${SCRIPT}" "${CHECKS_ACTUAL}" "${CHECKS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No actual!\n'

VALUES=('a' '-' ' ' $'\n' $'\t' '-0' '+0' '+1' '0.5' '0,5' '05')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_ACTUAL="${VALUE}"
 CHECKS_EXPECTED=''
 "${SCRIPT}" "${CHECKS_ACTUAL}" "${CHECKS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" "Actual(${#CHECKS_ACTUAL}): \"${CHECKS_ACTUAL}\" is not a number!"$'\n'
done

VALUES=('-2147483649' '2147483648')
 for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_ACTUAL="${VALUE}"
 CHECKS_EXPECTED=''
 "${SCRIPT}" "${CHECKS_ACTUAL}" "${CHECKS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" "Actual: ${CHECKS_ACTUAL} is not an int32!"$'\n'
done

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_ACTUAL='1'
CHECKS_EXPECTED=''
"${SCRIPT}" "${CHECKS_ACTUAL}" "${CHECKS_EXPECTED}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No expected!\n'

echo 'Not implemented!'; exit 1 # todo

#

rm "${STDOUT}"
rm "${STDERR}"
