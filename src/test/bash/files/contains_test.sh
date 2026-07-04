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

#

echo 'Not implemented!'; exit 1 # todo

:> "${STDERR}"
TMP_PATH="$(mktemp)"
printf '%s' 'foo' > "${TMP_PATH}"
"${SCRIPT}" "${TMP_PATH}" "${ASSERTS_SUBTEXT}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
EXPECTED_VALUE="\"${TMP_PATH}\"
does not contain:
---(${#ASSERTS_SUBTEXT})
${ASSERTS_SUBTEXT}
---"
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "${EXPECTED_VALUE}" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

ACTUAL_TEXT='--foo--'
ASSERTS_SUBTEXTS=('-' '--' '--foo' 'foo--' '--foo--')
for ASSERTS_SUBTEXT in "${ASSERTS_SUBTEXTS[@]}"; do
 :> "${STDERR}"
 printf '%s' "${ACTUAL_TEXT}" > "${TMP_PATH}"
 "${SCRIPT}" "${TMP_PATH}" "${ASSERTS_SUBTEXT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

ASSERTS_SUBTEXT='foo'
ACTUAL_TEXTS=(
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
for ACTUAL_TEXT in "${ACTUAL_TEXTS[@]}"; do
 :> "${STDERR}"
 printf '%s' "${ACTUAL_TEXT}" > "${TMP_PATH}"
 "${SCRIPT}" "${TMP_PATH}" "${ASSERTS_SUBTEXT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done

ASSERTS_SUBTEXT=$'foo\nbar'
ACTUAL_TEXTS=(
    $'foo\nbar\n' $'\nfoo\nbar'     $'\nfoo\nbar\n'
   $'xfoo\nbar\n'   $'foo\nbar\nx'   $'xfoo\nbar\nx'
 $'x\nfoo\nbar'   $'\nfoo\nbarx'   $'x\nfoo\nbarx'
 $'x\nfoo\nbar\n' $'\nfoo\nbar\nx' $'x\nfoo\nbar\nx'
)
for ACTUAL_TEXT in "${ACTUAL_TEXTS[@]}"; do
 :> "${STDERR}"
 printf '%s' "${ACTUAL_TEXT}" > "${TMP_PATH}"
 "${SCRIPT}" "${TMP_PATH}" "${ASSERTS_SUBTEXT}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done
rm "${TMP_PATH}"

#

rm "${STDOUT}"
rm "${STDERR}"
