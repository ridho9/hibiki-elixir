#!/usr/bin/env bash

LATEST_TAG=$(git tag --sort=-committerdate | head -n1)

cat ../docker-compose.yml | sed 's|rid9/hibiki-elixir:.*$|rid9/hibiki-elixir:$LATEST_TAG|'