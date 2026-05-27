#!/usr/local/bin/bash

if [[ ! -d "${asserts}" ]]; then
 echo 'No asserts!'; exit 1; fi

tests='src/test/bash'

. $tests/eq_test.sh
. $tests/ne_test.sh

. $tests/check_coverage.sh

. $tests/license_test.sh
. $tests/readme_test.sh

echo 'All tests were successful.'
