use Mix.Config

# db ##########################################################################

# Configure file upload
config :arc, storage: Arc.Storage.Local

# Configure your database
config :db, DB.Repo,
  hostname: "localhost",
  username: System.get_env("FW_DB_USERNAME") || "postgres",
  password: System.get_env("FW_DB_PASSWORD") || "postgres",
  database: "faithful_word_test",
  pool: Ecto.Adapters.SQL.Sandbox

# faithful_word ###############################################################

# Configure your database
config :faithful_word, DB.Repo,
  database: "faithful_word_test",
  pool: Ecto.Adapters.SQL.Sandbox

config :faithful_word, FaithfulWord.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-6-lwae88m8q5gefyfzuv-k1j33f05666",
  domain: "sandbox30725.mailgun.org"

# config :faithful_word, FaithfulWordApi.Auth.Guardian,
#   secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
#   issuer: "FaithfulWordApi"

# faithful_word_api ###########################################################

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :faithful_word_api, FaithfulWordApi.Endpoint,
  http: [port: 4002],
  server: false

# config :faithful_word_api, FaithfulWordApi.Auth.Guardian,
#   issuer: "FaithfulWordApi",
#   secret_key: "ft8TBDLTR8kFdU253xYhBxzX6aTyJK+dJKkGGUo8Ju8vPCgo5IEX590sh6OgY0s6"

# faithful_word_jobs ##########################################################

# Disable CRON tasks on test
config :faithful_word_jobs, FaithfulWord.Jobs.Scheduler, jobs: []

# General #####################################################################

config :logger,
  level: :debug,
  backends: [:console],
  compile_time_purge_level: :debug
