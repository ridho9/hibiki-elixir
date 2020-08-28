#!/usr/bin/env bash

LATEST_TAG=$(git tag --sort=-committerdate | head -n1)
echo checkout to $LATEST_TAG
git checkout $LATEST_TAG