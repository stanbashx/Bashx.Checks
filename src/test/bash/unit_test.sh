#!/usr/local/bin/bash

tests='src/test/bash'

. $tests/check_coverage.sh

. $tests/license_test.sh
. $tests/readme_test.sh

echo 'All tests were successful.'
