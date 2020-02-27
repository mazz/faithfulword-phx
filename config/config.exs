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
  youtube_api_key: System.get_env("FW_YOUTUBE_API_KEY"),
  oauth: [
    facebook: [
      client_id: System.get_env("FW_FACEBOOK_CLIENT_ID"),
      client_secret: System.get_env("FW_FACEBOOK_CLIENT_SECRET"),
      redirect_uri: Path.join(frontend_url, "login/callback/facebook")
    ]
  ]



config :ex_aws,
  access_key_id: [System.get_env("FW_AWS_ACCESS_KEY_ID"), :instance_role],
  secret_access_key: [System.get_env("FW_AWS_SECRET_ACCESS_KEY"), :instance_role]

config :arc,
  bucket: {:system, System.get_env("FW_ARC_S3_BUCKET")}

config :faithful_word, FaithfulWord.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: System.get_env("FW_MAILGUN_API_KEY"),
  domain: System.get_env("FW_MAILGUN_DOMAIN")

config :pigeon, :fcm,
  fcm_default: %{
    key:
    System.get_env("FW_PIGEON_KEY")
  }

# config :faithful_word, FaithfulWordApi.Auth.Guardian,
#   secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
#   issuer: "FaithfulWordApi"

config :faithful_word, FaithfulWord.Authenticator.GuardianImpl,
  secret_key: System.get_env("FW_GUARDIAN_SECRET_KEY"),
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
  check_origin: ["//localhost", "//#{System.get_env("FW_HOSTNAME")}"],
  secret_key_base: System.get_env("FW_SECRET_KEY_BASE"),
  render_errors: [view: FaithfulWordApi.ErrorView, accepts: ~w(html json)],
  pubsub: [name: FaithfulWordApi.PubSub, adapter: Phoenix.PubSub.PG2],
  instrumenters: [FaithfulWordApi.PhoenixInstrumenter]

config :prometheus, FaithfulWordApi.PipelineInstrumenter,
  labels: [:status_class, :method, :host, :scheme, :request_path],
  duration_buckets: [
    10,
    100,
    1_000,
    10_000,
    100_000,
    300_000,
    500_000,
    750_000,
    1_000_000,
    1_500_000,
    2_000_000,
    3_000_000
  ],
  registry: :default,
  duration_unit: :microseconds

config :faithful_word_api, FaithfulWordApi.Guardian,
  issuer: "FaithfulWordApi",
  secret_key: System.get_env("FW_API_GUARDIAN_SECRET_KEY")

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
