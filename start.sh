#!/bin/bash

set -e # Exit with nonzero exit code if anything fails

echo "adding runner for: $REPO on host: $HOST"

REG_TOKEN=$(curl -sX POST -H "Authorization: token ${ACCESS_TOKEN}" "https://api.github.com/repos/${REPO}/actions/runners/registration-token" | jq .token --raw-output)

cd /home/github/runner || exit 1 

./config.sh --unattended --url "https://github.com/${REPO}" --token "${REG_TOKEN}" --labels "${ENVIRONMENT}" --name "${HOST}"

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token "${REG_TOKEN}" 
}

trap 'cleanup; exit 130' EXIT INT ABRT TERM

./run.sh & wait $! # run.sh is a blocking process, so we need to run it in the background and wait for it to exit
