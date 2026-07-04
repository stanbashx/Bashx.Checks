#!/usr/local/bin/bash

SCRIPT='src/main/bash/files/not_empty.sh'

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
"${SCRIPT}" '' '' > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'Wrong arguments!'$'\n'

#

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH=''
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" 'No path!'$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
rm "${CHECKS_PATH}"
ln -s "${CHECKS_PATH}" "${CHECKS_PATH}"
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is a symlink!"$'\n'
rm "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
rm "${CHECKS_PATH}"
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" does not exist!"$'\n'

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp -d)"
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is not a file!"$'\n'
rm -r "${CHECKS_PATH}"

:> "${STDOUT}"
:> "${STDERR}"
CHECKS_PATH="$(mktemp)"
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" is empty!"$'\n'
rm "${CHECKS_PATH}"

echo 'Not implemented!'; exit 1 # todo

VALUES=(
 'a' ' ' $'\t' $'\n' $'\r' $'\v' $'\f' $'\x01'
 '!' '"' '#' '$' '%' '&' "'" '(' ')' '*' '+' ',' '-' '.' '/'
 ':' ';' '<' '=' '>' '?' '@' '[' ']' '^' '_' '`' '{' '|' '}' '~' '\'
)
for VALUE in "${VALUES[@]}"; do
 :> "${STDOUT}"
 :> "${STDERR}"
done

echo 'Not implemented!'; exit 1 # todo

:> "${STDERR}"

TMP_PATH="$(mktemp)"
"${SCRIPT}" "${TMP_PATH}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" is empty!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

TMP_PATH="$(mktemp)"
ACTUAL_TEXTS=(
 'a' ' ' $'\t' $'\n' $'\r' $'\v' $'\f' $'\x01'
 '!' '"' '#' '$' '%' '&' "'" '(' ')' '*' '+' ',' '-' '.' '/'
 ':' ';' '<' '=' '>' '?' '@' '[' ']' '^' '_' '`' '{' '|' '}' '~' '\'
)
for ACTUAL_TEXT in "${ACTUAL_TEXTS[@]}"; do
 :> "${STDERR}"
 printf '%s' "${ACTUAL_TEXT}" > "${TMP_PATH}"
 "${SCRIPT}" "${TMP_PATH}" 2>"${STDERR}"; CODE=$?
 if [[ "${CODE}" != '0' ]]; then
  echo "Code(${CODE}) error!" >&2; exit 1; fi
 ACTUAL_VALUE="$(<"${STDERR}")"
 if [[ -n "${ACTUAL_VALUE}" ]]; then
  echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
done
rm "${TMP_PATH}"

:> "${STDERR}"

TMP_PATH="$(mktemp)"
printf '42' > "${TMP_PATH}"
"${SCRIPT}" "${TMP_PATH}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '0' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ -n "${ACTUAL_VALUE}" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

#

rm "${STDOUT}"
rm "${STDERR}"
