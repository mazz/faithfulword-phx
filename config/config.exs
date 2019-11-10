# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

# db ##########################################################################

config :db,
  ecto_repos: [Db.Repo]

# faithful_word ###############################################################

frontend_url = String.trim_trailing("http://localhost:3000/") <> "/"

config :faithful_word,
  env: Mix.env(),
  ecto_repos: [Db.Repo],
  frontend_url: frontend_url,
  invitation_system: false,
  # fwsaved-web
  youtube_api_key: "AIzaSyB01nsJz0y24aXMqbX34oJ9Y4ywh0koKe4",
  oauth: [
    facebook: [
      client_id: "client_id",
      client_secret: "client_secret",
      redirect_uri: Path.join(frontend_url, "login/callback/facebook")
    ]
  ]

config :ex_aws,
  access_key_id: ["access_key_id", :instance_role],
  secret_access_key: ["secret_access_key", :instance_role]

config :arc,
  bucket: {:system, "AWS_S3_BUCKET"}

config :faithful_word, FaithfulWord.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-6-lwae88m8q5gefyfzuv-k1j33f05666",
  domain: "sandbox30725.mailgun.org"

config :pigeon, :fcm,
  fcm_default: %{
    key:
      "AAAA7hc7NSo:APA91bFIP2n9IHrcBxitXcV8BWfdY_bb8BDEljEAh8o4EqUZZZWUNhEzi360upRcySV9gRVyL9kEoXSCUtCm9DZEyvE4JQbTSsN1n1ocCZ-lMOjD2e4M_J_u-ij05UI0o1pTh_dfzVd3"
  }

# config :faithful_word, FaithfulWordApi.Auth.Guardian,
#   secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
#   issuer: "FaithfulWordApi"

config :faithful_word, FaithfulWord.Authenticator.GuardianImpl,
  secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
  issuer: "FaithfulWord",
  ttl: {30, :days},
  serializer: FaithfulWord.Accounts.GuardianSerializer,
  permissions: %{default: [:read, :write]}

config :faithful_word,
  captions_fetcher: FaithfulWord.Videos.CaptionsFetcherYoutube

config :guardian, Guardian.DB, repo: Db.Repo

config :rollbax,
  enabled: true,
  access_token: "a68f30a241f64dddab0349d1f4375506",
  environment: "production"

# faithful_word_api ###########################################################
config :faithful_word_api,
  ecto_repos: [Db.Repo],
  generators: [context_app: :db, binary_id: true]

config :faithful_word_api,
  cors_origins: "*"

# Configures the endpoint
config :faithful_word_api, FaithfulWordApi.Endpoint,
  # url: [host: "api.faithfulword.app"],
  check_origin: ["//localhost", "//api.faithfulword.app"],
  secret_key_base: "QI+125cFBB5Z+vR6D3ULCuhDalvbkd7Gse5zkpLrjhSK7sdm8XeNeB/Gq1zO5Gt8",
  render_errors: [view: FaithfulWordApi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FaithfulWordApi.PubSub, adapter: Phoenix.PubSub.PG2]

config :faithful_word_api, FaithfulWordApi.Guardian,
  issuer: "FaithfulWordApi",
  secret_key: "ft8TBDLTR8kFdU253xYhBxzX6aTyJK+dJKkGGUo8Ju8vPCgo5IEX590sh6OgY0s6"

# faithful_word_jobs ##########################################################

# Configure scheduler
config :faithful_word_jobs, FaithfulWord.Jobs.Scheduler,
  # Run only one instance across cluster
  global: true,
  debug_logging: false,
  jobs: [
    # credo:disable-for-lines:10
    # Actions analysers
    # Every minute
    # {{:extended, "*/20"}, {FaithfulWord.Jobs.Reputation, :update, []}},
    # Every day
    # {"@daily", {FaithfulWord.Jobs.Reputation, :reset_daily_limits, []}},
    # Every minute
    # {"*/1 * * * *", {FaithfulWord.Jobs.Flags, :update, []}},
    # Various updaters
    # Every 5 minutes
    # {"*/5 * * * *", {FaithfulWord.Jobs.Moderation, :update, []}}
  ]

# General #####################################################################

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
