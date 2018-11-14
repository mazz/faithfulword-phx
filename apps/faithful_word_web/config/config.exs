# Since configuration is shared in umbrella projects, this file
# should only configure the :faithful_word_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :faithful_word_web,
  ecto_repos: [FaithfulWord.Repo],
  generators: [context_app: :faithful_word, binary_id: true]

# Configures the endpoint
config :faithful_word_web, FaithfulWordWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "QI+125cFBB5Z+vR6D3ULCuhDalvbkd7Gse5zkpLrjhSK7sdm8XeNeB/Gq1zO5Gt8",
  render_errors: [view: FaithfulWordWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FaithfulWordWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
