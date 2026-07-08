#!/bin/bash

# Usage: ./run-all-tests.sh [path ...]
#   No arguments: run every test file in the repo.
#   With arguments: run the given .rkt files, and/or all test files
#   found under the given directories, e.g.
#       ./run-all-tests.sh tests/logic-test.rkt
#       ./run-all-tests.sh types

# Firetruck red, vibrant green, nice blue, no bold/italic
RED='\033[31m'
GREEN='\033[32m'
BLUE='\033[94m'
RESET='\033[0m'

root="$(cd "$(dirname "$0")" && pwd)"

# All test output collects here so the summary comes from the same
# single run that is displayed live; file_output holds one file's output
test_output_file=$(mktemp)
file_output=$(mktemp)
trap 'rm -f "$test_output_file" "$file_output"' EXIT

# Every .rkt inside a 'tests' directory is a test;
# tests/helpers/ holds shared modules, not tests, so it is skipped
find_tests() {
    find "$1" -path "*/tests/helpers" -prune -o -path "*/tests/*" -type f -name "*.rkt" -print0 | sort -z
}

test_files=()
if [ "$#" -eq 0 ]; then
    while IFS= read -r -d '' f; do test_files+=("$f"); done < <(find_tests "$root")
else
    for target in "$@"; do
        if [ -f "$target" ]; then
            test_files+=("$target")
        elif [ -d "$target" ]; then
            while IFS= read -r -d '' f; do test_files+=("$f"); done < <(find_tests "$target")
        else
            echo "No such file or directory: $target"
            exit 2
        fi
    done
fi

if [ "${#test_files[@]}" -eq 0 ]; then
    echo "No test files found."
    exit 2
fi

failed_files=()

for test_file in "${test_files[@]}"; do
    echo "***************************************************"
    echo ""
    echo "Running $test_file..."
    echo ""
    start=$(date +%s.%N)
    racket "$test_file" | tee "$file_output"
    end=$(date +%s.%N)
    cat "$file_output" >> "$test_output_file"

    elapsed=$(awk -v s="$start" -v e="$end" 'BEGIN { printf "%.1f", e - s }')
    file_results=$(grep "^-- .* results:" -A 1 "$file_output" | grep -v "^---")
    file_fails=$(echo "$file_results" | awk '{ fails += $1 } END { print fails+0 }')
    # A file that produced no results lines (e.g. crashed) counts as failed
    if [ -n "$file_results" ] && [ "$file_fails" -eq 0 ]; then
        printf "%b\n" "${GREEN}PASS${RESET} $test_file (${elapsed}s)"
    else
        printf "%b\n" "${RED}FAIL${RESET} $test_file (${elapsed}s)"
        failed_files+=("$test_file")
    fi
done

# Print test summary after all tests have completed
echo ""
echo "=== TEST SUMMARY ==="

results=$(grep "^-- .* results:" -A 1 "$test_output_file" | grep -v "^---")
if [ -z "$results" ]; then
    echo "No test results found."
    exit 1
fi

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

if [ "${#failed_files[@]}" -gt 0 ]; then
    echo ""
    printf "%b\n" "${RED}Failing files:${RESET}"
    for f in "${failed_files[@]}"; do
        printf "%b\n" "${RED} - $f${RESET}"
    done
fi

# Exit nonzero if any test failed so CI (and scripts) can detect a red suite
total_fails=$(echo "$results" | awk '{ fails += $1 } END { print fails+0 }')
[ "$total_fails" -eq 0 ] && [ "${#failed_files[@]}" -eq 0 ]
