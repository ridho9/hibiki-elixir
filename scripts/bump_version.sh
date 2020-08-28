#!/usr/bin/env bash

DIFF_FILES=$(git diff --name-only)

if [ -n "$DIFF_FILES" ]; then
    echo FOUND UNCOMMITED FILES: $DIFF_FILES
    echo commit all uncommitted files first
    exit 1
fi

VER=$1

if [ -z "$VER" ]; then
    echo missing version
    exit 1
fi

echo bumping version to $VER
git tag $VER
git push origin master $VER