#!/bin/bash

MIX_ENV=${MIX_ENV:prod}

echo "Starting daemon"
./_build/$MIX_ENV/rel/hibiki/bin/hibiki daemon