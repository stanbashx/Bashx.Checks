#!/usr/local/bin/bash

SCRIPT='src/main/bash/strings/contains.sh'

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
"${SCRIPT}" '' '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_TEXT='a'
CHECKS_SUBTEXT=''
CHECKS_MESSAGE=''
"${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_SUBTEXT}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No message!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_TEXT='a'
CHECKS_SUBTEXT=''
"${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No subtext!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_TEXT='a'
CHECKS_SUBTEXT='b'
"${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDOUT}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_TEXT='a'
CHECKS_SUBTEXT='b'
CHECKS_MESSAGE='c'
"${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_SUBTEXT}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "${CHECKS_MESSAGE}"$'\n'

#

VALUES=('-' '--' '--foo' 'foo--' '--foo--')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_TEXT='--foo--'
 CHECKS_SUBTEXT="${VALUE}"
 "${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDOUT}"
done

VALUES=(
 'qux foo bar'
     'foo'      'foo foo'    'foo bar'
     'foox'    'xfoo'       'xfoox'
     'foo*'    '*foo'       '*foo*'
     'foo.'    '.foo'       '.foo.'
     'foo '    ' foo'       ' foo '
    $'foo\n' $'\nfoo'     $'\nfoo\n'
   $'xfoo\n'   $'foo\nx'   $'xfoo\nx'
 $'x\nfoo'   $'\nfoox'   $'x\nfoox'
 $'x\nfoo\n' $'\nfoo\nx' $'x\nfoo\nx'
)
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_TEXT="${VALUE}"
 CHECKS_SUBTEXT='foo'
 "${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDOUT}"
done

VALUES=(
    $'foo\nbar\n' $'\nfoo\nbar'     $'\nfoo\nbar\n'
   $'xfoo\nbar\n'   $'foo\nbar\nx'   $'xfoo\nbar\nx'
 $'x\nfoo\nbar'   $'\nfoo\nbarx'   $'x\nfoo\nbarx'
 $'x\nfoo\nbar\n' $'\nfoo\nbar\nx' $'x\nfoo\nbar\nx'
)
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_TEXT="${VALUE}"
 CHECKS_SUBTEXT=$'foo\nbar'
 "${SCRIPT}" "${CHECKS_TEXT}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDOUT}"
done

#

rm "${STDOUT}"
rm "${STDERR}"
