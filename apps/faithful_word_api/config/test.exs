# Since configuration is shared in umbrella projects, this file
# should only configure the :faithful_word_api application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :faithful_word_api, FaithfulWordApi.Endpoint,
  http: [port: 4002],
  server: false


# config :faithful_word_api, FaithfulWordApi.Auth.Guardian,
#   issuer: "FaithfulWordApi",
#   secret_key: "ft8TBDLTR8kFdU253xYhBxzX6aTyJK+dJKkGGUo8Ju8vPCgo5IEX590sh6OgY0s6"
