#!/bin/bash
# Test build.sh with missing apps.json
echo "Testing build.sh with missing apps.json"
echo "Expected: Error message about apps.json not found"

# Temporarily rename apps.json
if [ -f "../../apps.json" ]; then
  mv ../../apps.json ../../apps.json.bak

  # Execute build.sh with missing apps.json
  ../../scripts/build.sh

  # The script should exit with an error code
  if [ $? -ne 0 ]; then
    echo "Test passed: Script exited with error as expected"
  else
    echo "Test failed: Script did not exit with error"
  fi

  # Restore apps.json
  mv ../../apps.json.bak ../../apps.json
else
  echo "Test skipped: apps.json not found"
fi
