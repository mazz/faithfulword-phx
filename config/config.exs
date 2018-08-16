# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :olivetree,
  ecto_repos: [Olivetree.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :olivetree, OlivetreeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jRHmPC7IBcXtJdHCX0bEOePKYwavyeyOIlKVIV13VEVkvoGlBv/lQV3CHPh4RoKr",
  render_errors: [view: OlivetreeWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Olivetree.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

  config :olivetree, Olivetree.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-6-lwae88m8q5gefyfzuv-k1j33f05666",
  domain: "sandbox30725.mailgun.org"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
