#!/usr/local/bin/bash

SCRIPT='src/main/bash/files/exists.sh'

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
"${SCRIPT}" "${CHECKS_PATH}" > "${STDOUT}" 2> "${STDERR}"
. $asserts/ints/eq.sh "${SCRIPT}" "$?" 1
. $asserts/files/empty.sh "${STDOUT}"
. $asserts/files/equals.sh "${STDERR}" "\"${CHECKS_PATH}\" does not exist!"$'\n'

echo 'Not implemented!'; exit 1 # todo

:> "${STDERR}"

TMP_PATH="$(mktemp -d)"
"${SCRIPT}" "${TMP_PATH}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" is not a file!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm -rf "${TMP_PATH}"

:> "${STDERR}"

TMP_PATH="$(mktemp)"
rm "${TMP_PATH}"
ln -s "${TMP_PATH}" "${TMP_PATH}" && [[ -L "${TMP_PATH}" ]] || exit 1
"${SCRIPT}" "${TMP_PATH}" 2>"${STDERR}"; CODE=$?
if [[ "${CODE}" != '1' ]]; then
 echo "Code(${CODE}) error!" >&2; exit 1; fi
ACTUAL_VALUE="$(<"${STDERR}")"
if [[ "${ACTUAL_VALUE}" != "\"${TMP_PATH}\" is a symlink!" ]]; then
 echo "Actual value(${#ACTUAL_VALUE}) is: \"${ACTUAL_VALUE}\"!" >&2; exit 1; fi
rm "${TMP_PATH}"

:> "${STDERR}"

TMP_PATH="$(mktemp)"
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
