#!/usr/bin/env bash

LATEST_TAG=$(git tag --sort=-committerdate | head -n1)

cat docker-compose.yml | sed "s|__TAG__|${LATEST_TAG}|" | tee ../docker-compose.yml
echo update docker-compose to $LATEST_TAG

cd ..

docker-compose up -d

cd src