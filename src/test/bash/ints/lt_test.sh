#!/usr/local/bin/bash

SCRIPT='src/main/bash/ints/lt.sh'

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
CHECKS_VAL=''
CHECKS_REF=''
CHECKS_MESSAGE=''
"${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No message!\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_VAL=''
CHECKS_REF=''
"${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No value!\n'

VALUES=('a' '-' ' ' $'\n' $'\t' '-0' '+0' '+1' '0.5' '0,5' '05')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_VAL="${VALUE}"
 CHECKS_REF=''
 "${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" "Value(${#CHECKS_VAL}): \"${CHECKS_VAL}\" is not a number!"$'\n'
done

VALUES=('-2147483649' '2147483648')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_VAL="${VALUE}"
 CHECKS_REF=''
 "${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" "Value: ${CHECKS_VAL} is not an int32!"$'\n'
done

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_VAL='1'
CHECKS_REF=''
"${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" $'No reference!\n'

VALUES=('a' '-' ' ' $'\n' $'\t' '-0' '+0' '+1' '0.5' '0,5' '05')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_VAL='42'
 CHECKS_REF="${VALUE}"
 "${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" "Reference(${#CHECKS_REF}): \"${CHECKS_REF}\" is not a number!"$'\n'
done

VALUES=('-2147483649' '2147483648')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_VAL='42'
 CHECKS_REF="${VALUE}"
 "${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" "Reference: ${CHECKS_REF} is not an int32!"$'\n'
done

#

VALUES=('64' '128' '256' '2147483647')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_VAL='42'
 CHECKS_REF="${VALUE}"
 "${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_MESSAGE='foo'
 "${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
done

echo 'Not implemented!'; exit 1 # todo

VALUES=('-42' '-8' '0' '1' '2' '4' '8' '16' '32' '64' '-2147483648' '2147483647')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_VAL="${VALUE}"
 CHECKS_REF="${VALUE}"
 "${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
 CHECKS_MESSAGE='foo'
 "${SCRIPT}" "${CHECKS_VAL}" "${CHECKS_REF}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
done

#

rm "${STDOUT}"
rm "${STDERR}"
