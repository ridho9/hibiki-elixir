#!/usr/bin/env bash


ssh -T root@hibiki.ridho.dev << EOF
    cd hibiki-elixir/src
    git checkout master
    git pull

    ./scripts/checkout_latest_tag.sh && \
    ./scripts/build.sh && \
    ./scripts/update_compose.sh

    git checkout master
EOF