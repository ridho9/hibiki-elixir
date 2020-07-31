#!/bin/bash

MIX_ENV=prod mix release

cd _build/prod/rel/hibiki_elixir
zip -r ../../../../hibiki-release.zip *