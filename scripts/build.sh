#!/usr/bin/env bash

LATEST_TAG=$(git tag --sort=-committerdate | head -n1)

DIFF_FILES=$(git diff --name-only)

if [ -n "$DIFF_FILES" ]; then
    echo FOUND UNCOMMITED FILES: $DIFF_FILES
    echo cancelling build
    exit 1
fi

echo start build rid9/hibiki-elixir:$LATEST_TAG

docker build --build-arg TAG=$LATEST_TAG -t rid9/hibiki-elixir:$LATEST_TAG .

echo finish build rid9/hibiki-elixir:$LATEST_TAG