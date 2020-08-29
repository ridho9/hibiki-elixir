#!/usr/bin/env bash


ssh root@hibiki.ridho.dev /bin/bash << EOF
    cd hibiki-elixir/src
    git checkout master
    git pull

    ./scripts/checkout_latest_tag.sh && \
    ./scripts/build.sh && \
    ./scripts/update_compose.sh

    git checkout master
EOF