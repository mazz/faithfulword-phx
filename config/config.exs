# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :faithfulword,
  ecto_repos: [Faithfulword.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :faithfulword, FaithfulwordWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jRHmPC7IBcXtJdHCX0bEOePKYwavyeyOIlKVIV13VEVkvoGlBv/lQV3CHPh4RoKr",
  render_errors: [view: FaithfulwordWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Faithfulword.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

config :faithfulword, Faithfulword.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-6-lwae88m8q5gefyfzuv-k1j33f05666",
  domain: "sandbox30725.mailgun.org"
  # domain: "objectaaron.com"

config :faithfulword, FaithfulwordWeb.Guardian,
  secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
  issuer: "Faithfulword",
  token_ttl: %{
    "magic" => {30, :minutes},
    "access" => {1, :days}
  }


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
