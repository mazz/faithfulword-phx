FROM elixir:1.9.1-alpine as build

ARG APP_NAME=faithful_word
ARG ASSETS_PATH=apps/faithful_word_api/assets

# install build dependencies
RUN apk --no-cache --update add alpine-sdk build-base nodejs nodejs-npm

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
RUN HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix do deps.get, deps.compile

COPY ${ASSETS_PATH} ${ASSETS_PATH}
COPY rel rel

RUN cd ${ASSETS_PATH} && \
  npm install --no-optional && \
  npm run deploy && \
  cd - && \
  mix do compile, phx.digest, release

RUN mv _build/prod/rel/${APP_NAME} /opt/release && \
    mv /opt/release/bin/${APP_NAME} /opt/release/bin/start_server && \
    mv rel/docker-entrypoint.sh /opt/release/bin/docker-entrypoint.sh


FROM alpine:3.9 as app
RUN apk --no-cache --update add bash openssl-dev postgresql-client
WORKDIR /opt/app
EXPOSE 4000
COPY --from=build /opt/release ./
RUN chown -R nobody: /opt/app
USER nobody

RUN chmod +x /opt/app/bin/docker-entrypoint.sh
CMD ["/opt/app/bin/docker-entrypoint.sh"]
