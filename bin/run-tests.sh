#!/usr/bin/env bash

# Synopsis:
# Test the test runner by running it against a predefined set of solutions 
# with an expected output.

# Output:
# Outputs the diff of the expected test results against the actual test results
# generated by the test runner.

# Example:
# ./bin/run-tests.sh

set -o pipefail
set -u

exit_code=0

base_dir=$(builtin cd "${BASH_SOURCE%/*}/.." || exit; pwd)

# Iterate over all test Spago projects
for config in "${base_dir}"/tests/*/spago.dhall; do
    exercise_dir=$(dirname "${config}")
    slug=$(basename "${exercise_dir}")
    expected_results_file="${exercise_dir}/expected_results.json"
    actual_results_file="${exercise_dir}/results.json"

    bin/run.sh "${slug}" "${exercise_dir}" "${exercise_dir}"

    echo "${slug}: comparing results.json to expected_results.json"

    if ! diff -u "${actual_results_file}" "${expected_results_file}"; then
        exit_code=1
    fi
done

exit ${exit_code}