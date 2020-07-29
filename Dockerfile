FROM elixir:1.10.4-alpine as builder

ARG MIX_ENV=prod

WORKDIR /src

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
COPY rel ./rel
COPY apps ./apps
COPY config ./config

RUN mix deps.get && \
    mix release

# ===========================================

FROM alpine:3
RUN apk add --no-cache openssl ncurses-libs bash

WORKDIR /app
COPY --from=builder /src/_build/prod/rel/hibiki_elixir/ .

EXPOSE 8080

ENTRYPOINT ["/app/bin/hibiki_elixir"]
CMD ["start"]