#!/bin/bash

# Should be done after pull and doing migration if needed

MIX_ENV=${MIX_ENV:prod}

echo "Building release, env $MIX_ENV"
mix release

./scripts/stop.sh
./scripts/daemon.sh