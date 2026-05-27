#!/usr/local/bin/bash

# todo unit_test.sh -> check_tests.sh

if [[ ! -d "${asserts}" ]]; then
 echo 'No asserts!'; exit 1; fi

tests='src/test/bash'

. $tests/eq_test.sh
. $tests/ne_test.sh

. $tests/check_coverage.sh

. $tests/check_license.sh
. $tests/check_readme.sh

echo 'All tests were successful.'
