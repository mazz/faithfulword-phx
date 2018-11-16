# Since configuration is shared in umbrella projects, this file
# should only configure the :faithful_word_api application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :faithful_word_api,
  ecto_repos: [FaithfulWord.Repo],
  generators: [context_app: :faithful_word, binary_id: true]

# Configures the endpoint
config :faithful_word_api, FaithfulWordApi.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QI+125cFBB5Z+vR6D3ULCuhDalvbkd7Gse5zkpLrjhSK7sdm8XeNeB/Gq1zO5Gt8",
  render_errors: [view: FaithfulWordApi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FaithfulWordApi.PubSub, adapter: Phoenix.PubSub.PG2]

config :faithful_word, FaithfulWord.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-6-lwae88m8q5gefyfzuv-k1j33f05666",
  domain: "sandbox30725.mailgun.org"
  # domain: "objectaaron.com"

config :faithful_word_api, FaithfulWordApi.Guardian,
  secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
  issuer: "FaithfulWord",
  token_ttl: %{
    "magic" => {30, :minutes},
    "access" => {1, :days}
  }

config :recaptcha,
  public_key: {:system, "hBzfjdYMN6jVEACa/n1HE9DCLLT23K3a9XgPJrE8A9FWltZ2IJYzJ18rbSZDJRss"},
  secret: {:system, "ElzXHXqoPHbsKOf06eErAXonnJx4JuCksEtttbzOgAaOTfsniPrmr3W9FfdB6wqo"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
