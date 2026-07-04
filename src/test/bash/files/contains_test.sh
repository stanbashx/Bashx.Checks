#!/usr/local/bin/bash

SCRIPT='src/main/bash/files/contains.sh'

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
"${SCRIPT}" '' '' '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH=''
CHECKS_SUBTEXT=''
"${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No path!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
rm "${CHECKS_PATH}"
ln -s "${CHECKS_PATH}" "${CHECKS_PATH}"
CHECKS_SUBTEXT=''
"${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is a symlink!"$'\n'
rm "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
rm "${CHECKS_PATH}"
CHECKS_SUBTEXT=''
"${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" does not exist!"$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp -d)"
CHECKS_SUBTEXT=''
"${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is not a file!"$'\n'
rm -r "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
CHECKS_SUBTEXT=''
"${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is empty!"$'\n'
rm "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
printf '%s' 'foo' > "${CHECKS_PATH}"
CHECKS_SUBTEXT=''
"${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No subtext!'$'\n'
rm "${CHECKS_PATH}"

EXIT_CODES=(2 42 127)
for EXIT_CODE in "${EXIT_CODES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_PATH="$(mktemp)"
 printf '%s' 'foo' > "${CHECKS_PATH}"
 CHECKS_SUBTEXT='bar'
 PATH="$mocks/ripgrep/bin:${PATH}" \
  MOCKS_RIPGREP_EXIT_CODE="${EXIT_CODE}" \
  "${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" read error!"$'\n'
 rm "${CHECKS_PATH}"
done

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
printf '%s' 'foo' > "${CHECKS_PATH}"
CHECKS_SUBTEXT='bar'
CHECKS_MESSAGE=''
"${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" 'No message!'$'\n'
rm "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
printf '%s' 'foo' > "${CHECKS_PATH}"
CHECKS_SUBTEXT='bar'
CHECKS_MESSAGE='qux'
"${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" "${CHECKS_MESSAGE}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/equals.sh "${STDERR}" "${CHECKS_MESSAGE}"$'\n'
rm "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
printf '%s' 'foo' > "${CHECKS_PATH}"
CHECKS_SUBTEXT='bar'
"${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/empty.sh "${STDERR}"
rm "${CHECKS_PATH}"

VALUES=('-' '--' '--foo' 'foo--' '--foo--')
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
 CHECKS_PATH="$(mktemp)"
 printf '%s' '--foo--' > "${CHECKS_PATH}"
 CHECKS_SUBTEXT="${VALUE}"
 "${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
 rm "${CHECKS_PATH}"
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
 CHECKS_PATH="$(mktemp)"
 printf '%s' "${VALUE}" > "${CHECKS_PATH}"
 CHECKS_SUBTEXT='foo'
 "${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
 rm "${CHECKS_PATH}"
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
 CHECKS_PATH="$(mktemp)"
 printf '%s' "${VALUE}" > "${CHECKS_PATH}"
 CHECKS_SUBTEXT=$'foo\nbar'
 "${SCRIPT}" "${CHECKS_PATH}" "${CHECKS_SUBTEXT}" > "${STDOUT}" 2> "${STDERR}"
 . $asserts/ints/eq.sh "${SCRIPT}" "$?" 0
 . $asserts/files/empty.sh "${STDOUT}"
 . $asserts/files/empty.sh "${STDERR}"
 rm "${CHECKS_PATH}"
done

#

rm "${STDOUT}"
rm "${STDERR}"
