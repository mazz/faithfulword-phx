# docker build -t faithful_word:builder --target=builder .
FROM elixir:1.7.4-alpine as builder
RUN apk add --no-cache \
    gcc \
    git \
    make \
    musl-dev
RUN mix local.rebar --force && \
    mix local.hex --force
WORKDIR /app
ENV MIX_ENV=prod

# docker build -t faithful_word:deps --target=deps .
FROM builder as deps
COPY mix.* /app/
# Explicit list of umbrella apps
RUN mkdir -p \
    /app/apps/db \
    /app/apps/faithful_word \
    /app/apps/faithful_word_api
COPY apps/db/mix.* /app/apps/db/
COPY apps/faithful_word/mix.* /app/apps/faithful_word/
COPY apps/faithful_word_api/mix.* /app/apps/faithful_word_api/
RUN mix do deps.get --only prod, deps.compile

# docker build -t faithful_word:frontend --target=frontend .
FROM node:10.14-alpine as frontend
WORKDIR /app
COPY apps/faithful_word_api/assets/package*.json /app/
COPY --from=deps /app/deps/phoenix /deps/phoenix
COPY --from=deps /app/deps/phoenix_html /deps/phoenix_html
RUN npm ci
COPY apps/faithful_word_api/assets /app
RUN npm run deploy

# docker build -t faithful_word:releaser --target=releaser .
FROM deps as releaser
COPY . /app/
COPY --from=frontend /priv/static apps/faithful_word_api/priv/static
RUN mix do phx.digest, release --env=prod --no-tar

# docker run -it --rm elixir:1.7.3-alpine sh -c 'head -n1 /etc/issue'
FROM alpine:3.8 as runner
RUN addgroup -g 1000 faithful_word && \
    adduser -D -h /app \
      -G faithful_word \
      -u 1000 \
      faithful_word
RUN apk add -U bash libssl1.0
USER root
WORKDIR /app
COPY --from=releaser /app/_build/prod/rel/faithful_word_umbrella /app
EXPOSE 80
ENTRYPOINT ["/app/bin/faithful_word_umbrella"]
CMD ["foreground"]
