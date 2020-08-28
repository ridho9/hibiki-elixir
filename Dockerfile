FROM elixir:1.10.4-alpine as builder

ARG MIX_ENV=prod

WORKDIR /src

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
COPY apps/hibiki/mix.exs ./apps/hibiki/
COPY apps/hibiki_web/mix.exs ./apps/hibiki_web/
COPY apps/line_sdk/mix.exs ./apps/line_sdk/
COPY apps/teitoku/mix.exs ./apps/teitoku/

RUN mix do deps.get --only ${MIX_ENV}, deps.compile

COPY rel ./rel
COPY apps ./apps
COPY config ./config

ARG TAG
RUN mix do release
# RUN mix do deps.get --only ${MIX_ENV}, release

# ===========================================

FROM alpine:3
RUN apk add --no-cache openssl ncurses-libs bash file curl

WORKDIR /app
COPY --from=builder /src/_build/prod/rel/hibiki_elixir/ .

EXPOSE 8080

ENTRYPOINT ["/app/bin/hibiki_elixir"]
CMD ["start"]