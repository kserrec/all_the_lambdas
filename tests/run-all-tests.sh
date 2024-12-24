#!/bin/bash

# Iterate over all Racket test files and execute them
for test_file in *.rkt; do
    echo "***************************************************"
    echo ""
    echo "Running $test_file..."
    echo ""
    racket "$test_file"
done