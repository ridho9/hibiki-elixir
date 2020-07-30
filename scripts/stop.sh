#!/bin/bash

MIX_ENV=${MIX_ENV:prod}

echo "Stopping if already running"
./_build/$MIX_ENV/rel/hibiki/bin/hibiki stop