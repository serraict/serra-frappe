#!/bin/bash
# Test build.sh with invalid parameter
echo "Testing build.sh with invalid parameter"
echo "Expected: Error message about unknown option"

# Execute build.sh with invalid parameter
../../scripts/build.sh --invalid-param test

# The script should exit with an error code
if [ $? -ne 0 ]; then
  echo "Test passed: Script exited with error as expected"
else
  echo "Test failed: Script did not exit with error"
fi
