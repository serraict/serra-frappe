#!/bin/bash
# Run all build.sh tests
echo "Running all build.sh tests"
echo "=========================="

# Make all test scripts executable
chmod +x *.sh

# Function to run a test and report results
run_test() {
  echo
  echo "Running test: $1"
  echo "-----------------"

  # Skip actual Docker builds if requested
  if [ "$2" = "skip_build" ]; then
    echo "Skipping actual build for this test (would run: ./$1)"
    return
  fi

  # Run the test
  ./$1

  # Check result
  if [ $? -eq 0 ]; then
    echo "Test completed: $1"
  else
    echo "Test failed: $1"
  fi

  echo
}

# Ask if we should skip actual Docker builds
echo "Would you like to skip the actual Docker builds? (y/n)"
read -r skip_builds
if [ "$skip_builds" = "y" ] || [ "$skip_builds" = "Y" ]; then
  SKIP_OPTION="skip_build"
else
  SKIP_OPTION=""
fi

# Run all tests
run_test "test_default_params.sh" "$SKIP_OPTION"
run_test "test_custom_branch.sh" "$SKIP_OPTION"
run_test "test_custom_image_name.sh" "$SKIP_OPTION"
run_test "test_custom_image_tag.sh" "$SKIP_OPTION"
run_test "test_invalid_param.sh" ""  # Always run error tests
run_test "test_missing_apps_json.sh" ""  # Always run error tests
run_test "test_image_verification.sh" "$SKIP_OPTION"

echo
echo "All tests completed"
echo "==================="
