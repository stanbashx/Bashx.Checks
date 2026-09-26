#!/usr/local/bin/bash

SCRIPT='src/main/bash/exit.sh'

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
"${SCRIPT}" -c 1 -c 2 > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" '"-c" already used!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_EXIT_CODE=''
"${SCRIPT}" -c "${CHECKS_EXIT_CODE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No exit code!'$'\n'

VALUES=('a' '-' '-0' '-1' ' 1' $'\n1' $'\t1' '00' '01' '256' '1000')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_EXIT_CODE="${VALUE}"
 "${SCRIPT}" -c "${CHECKS_EXIT_CODE}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" 'Wrong exit code!'$'\n'
done

VALUES=(0 9 10 99 100 255)
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_EXIT_CODE="${VALUE}"
 "${SCRIPT}" -c "${CHECKS_EXIT_CODE}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" "${CHECKS_EXIT_CODE}"
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
done

#

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -o 1 -o 2 > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" '"-o" already used!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -o '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No stdout!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -e 1 -e 2 > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" '"-e" already used!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -e '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" '1'
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No stderr!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -c 42 > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 42
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -o 'foo' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/equals.sh "${STDOUT}" 'foo'$'\n'
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -e 'bar' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'bar'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -c 42 -o 'foo' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 42
. $asserts/files/equals.sh "${STDOUT}" 'foo'$'\n'
. $asserts/files/empty.sh "${STDERR}"

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -c 42 -e 'bar' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 42
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'bar'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -o 'foo' -e 'bar' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
. $asserts/files/equals.sh "${STDOUT}" 'foo'$'\n'
. $asserts/files/equals.sh "${STDERR}" 'bar'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
"${SCRIPT}" -c 42 -o 'foo' -e 'bar' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 42
. $asserts/files/equals.sh "${STDOUT}" 'foo'$'\n'
. $asserts/files/equals.sh "${STDERR}" 'bar'$'\n'

#

rm "${STDOUT}"
rm "${STDERR}"
