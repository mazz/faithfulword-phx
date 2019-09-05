FROM elixir:1.9.1-alpine as build

ARG APP_NAME=faithful_word

# install build dependencies
RUN apk --no-cache --update add alpine-sdk build-base

# prepare build dir
WORKDIR /opt/app

RUN mix local.rebar --force && \
  mix local.hex --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
COPY apps apps
COPY rel rel

RUN HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix do deps.get, deps.compile, compile, release

RUN mv _build/prod/rel/${APP_NAME} /opt/release && \
  mv /opt/release/bin/${APP_NAME} /opt/release/bin/start_server

FROM alpine:3.9 as app
RUN apk --no-cache --update add bash openssl-dev
WORKDIR /opt/app
EXPOSE 4000
COPY --from=build /opt/release ./
RUN chown -R nobody: /opt/app
USER nobody

ENTRYPOINT ["/opt/app/bin/start_server"]
CMD ["start"]
