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
