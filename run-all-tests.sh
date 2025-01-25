#!/bin/bash

# Firetruck red, vibrant green, nice blue, no bold/italic
RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[94m'
RESET='\033[0m'

# Find all 'tests' directories within the 'all_the_lambdas' directory and store them in an array
test_dirs=($(find "$(dirname "$0")" -type d -name "tests"))

# Iterate over each tests directory
for dir in "${test_dirs[@]}"; do
    echo "Checking directory: $dir"
    
    # Find and execute all .rkt files in the current tests directory
    while IFS= read -r -d '' test_file; do
        echo "***************************************************"
        echo ""
        echo "Running $test_file..."
        echo ""
        racket "$test_file"
    done < <(find "$dir" -type f -name "*.rkt" -print0)
done

# Print test summary after all tests have completed
echo ""
echo "=== TEST SUMMARY ==="

# Collect all test output into a file
test_output_file=$(mktemp)

# Re-run tests to capture results
for dir in "${test_dirs[@]}"; do
    find "$dir" -type f -name "*.rkt" -print0 | while IFS= read -r -d '' test_file; do
        racket "$test_file" | tee -a "$test_output_file"
    done
done

results=$(grep "^-- .* results:" -A 1 "$test_output_file" | grep -v "^---")
if [ -z "$results" ]; then
    echo "No test results found."
else
    echo "$results" | awk -v RED="$RED" -v GREEN="$GREEN" -v BLUE="$BLUE" -v RESET="$RESET" '
        BEGIN { fails=0; passes=0; total=0 }
        {
            fails += $1;
            passes += $3;
            total += $5;
        }
        END {
            printf "%s%d FAILS%s  %s%d PASS%s  %s%d TEST(s)%s\n",
                RED, fails, RESET,
                GREEN, passes, RESET,
                BLUE, total, RESET;
        }
    '
fi