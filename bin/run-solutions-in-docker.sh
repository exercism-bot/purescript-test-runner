#!/usr/bin/env bash

# Synopsis:
# Test the test runner Docker image by running it against a predefined set of 
# solutions with an expected output.
# The test runner Docker image is built automatically.

# Output:
# Outputs the diff of the expected test results against the actual test results
# generated by the test runner Docker image.

# Example:
# ./bin/run-tests-in-docker.sh

set -o pipefail
set -u

if [ $# != 1 ]; then
    echo "Usage ${BASH_SOURCE[0]} /path/to/exercises"
    exit 1
fi

base_dir=$(builtin cd "${BASH_SOURCE%/*}/.." || exit; pwd)
exercises_dir="${1%/}"

# Build the Docker image
docker build --rm -t exercism/test-runner "${base_dir}"

for config in "${exercises_dir}"/*/*/.solution.dhall; do
    exercise_dir=$(dirname "${config}")
    slug=$(basename "${exercise_dir}")

    echo "Working in ${exercise_dir}..."

    "${base_dir}/bin/run-in-docker.sh" "${slug}" "${exercise_dir}" /tmp
done