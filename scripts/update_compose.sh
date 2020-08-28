#!/usr/bin/env bash

LATEST_TAG=$(git tag --sort=-committerdate | head -n1)

cd ..
echo update docker-compose to $LATEST_TAG
cat docker-compose.yml | sed 's|rid9/hibiki-elixir:.*$|rid9/hibiki-elixir:$LATEST_TAG|' | tee docker-compose.yml


cd src