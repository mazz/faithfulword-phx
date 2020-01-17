FROM bitwalker/alpine-elixir-phoenix:1.9.0 as releaser

WORKDIR /app

# Install Hex + Rebar
RUN mix do local.hex --force, local.rebar --force

COPY config/ /app/config/
COPY mix.exs /app/
COPY mix.* /app/

COPY apps/db/mix.exs /app/apps/db/
COPY apps/faithful_word/mix.exs /app/apps/faithful_word/
COPY apps/faithful_word_api/mix.exs /app/apps/faithful_word_api/
COPY apps/faithful_word_jobs/mix.exs /app/apps/faithful_word_jobs/

ENV MIX_ENV=prod
# docker build --build-arg DATABASE_URL=ecto://postgres:postgres@localhost/registrar_dev
# ENV DATABASE_URL=ecto://postgres:postgres@postgres/faithful_word
# ENV SECRET_KEY_BASE=QI+125cFBB5Z+vR6D3ULCuhDalvbkd7Gse5zkpLrjhSK7sdm8XeNeB/Gq1zO5Gt8
RUN mix do deps.get --only $MIX_ENV, deps.compile

COPY . /app/

WORKDIR /app/apps/faithful_word_api
RUN MIX_ENV=prod mix compile
RUN npm install --prefix ./assets
RUN npm run deploy --prefix ./assets
RUN mix phx.digest

WORKDIR /app
RUN MIX_ENV=prod mix release

########################################################################

FROM bitwalker/alpine-elixir-phoenix:1.9.0

EXPOSE 4000
ENV FW_PORT=4000 \
    MIX_ENV=prod \
    SHELL=/bin/bash

WORKDIR /app
COPY --from=releaser app/_build/prod/rel/faithful_word_umbrella .
COPY --from=releaser app/bin/ ./bin

CMD ["./bin/start"]

# RUN chmod +x /app/bin/docker-entrypoint.sh
# CMD ["/app/bin/docker-entrypoint.sh"]

# docker build -t mhanna/faithful_word_umbrella .
# docker run -p 4000:4000 -p 5432:5432 --env COOL_TEXT='ELIXIR ROCKS!!!!' --env DATABASE_URL=ecto://postgres:postgres@localhost/faithful_word --env SECRET_KEY_BASE=QI+125cFBB5Z+vR6D3ULCuhDalvbkd7Gse5zkpLrjhSK7sdm8XeNeB/Gq1zO5Gt8 mhanna/faithful_word_umbrella:latest



# FROM elixir:1.9.1-alpine as build

# ARG APP_NAME=faithful_word
# ARG ASSETS_PATH=apps/faithful_word_api/assets

# # install build dependencies
# RUN apk --no-cache --update add alpine-sdk build-base nodejs nodejs-npm

# # prepare build dir
# WORKDIR /opt/app

# RUN mix local.rebar --force && \
#     mix local.hex --force

# # set build ENV
# ENV MIX_ENV=prod

# # install mix dependencies
# COPY mix.exs mix.lock ./
# COPY config config
# COPY apps apps
# RUN HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix do deps.get, deps.compile

# COPY ${ASSETS_PATH} ${ASSETS_PATH}
# COPY rel rel

# RUN cd ${ASSETS_PATH} && \
#   npm install --no-optional && \
#   npm run deploy && \
#   cd - && \
#   mix do compile, phx.digest, release

# RUN mv _build/prod/rel/${APP_NAME} /opt/release && \
#     mv /opt/release/bin/${APP_NAME} /opt/release/bin/start_server && \
#     mv rel/docker-entrypoint.sh /opt/release/bin/docker-entrypoint.sh


# FROM alpine:3.9 as app
# RUN apk --no-cache --update add bash openssl-dev postgresql-client
# WORKDIR /opt/app
# EXPOSE 4000
# COPY --from=build /opt/release ./
# RUN chown -R nobody: /opt/app
# USER nobody

# RUN chmod +x /opt/app/bin/docker-entrypoint.sh
# CMD ["/opt/app/bin/docker-entrypoint.sh"]
