# Since configuration is shared in umbrella projects, this file
# should only configure the :faithful_word application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :faithful_word,
  ecto_repos: [FaithfulWord.DB.Repo],
  oauth: [facebook: []]

config :faithful_word, FaithfulWord.Mailer,
  adapter: Bamboo.MailgunAdapter,
  api_key: "key-6-lwae88m8q5gefyfzuv-k1j33f05666",
  domain: "sandbox30725.mailgun.org"

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# config :faithful_word, FaithfulWordApi.Auth.Guardian,
#   secret_key: "pnggot8GyQJKcPpPpnt1hZ1iGO9MZWkBd09+T6aJOQ2lK3ao6AnNgk0sCbydY8dW",
#   issuer: "FaithfulWordApi"

config :faithful_word, FaithfulWord.Authenticator.Guardian,
  issuer: "FaithfulWord",
  ttl: {30, :days},
  serializer: FaithfulWord.Accounts.GuardianSerializer,
  permissions: %{default: [:read, :write]}

config :guardian, Guardian.DB, repo: FaithfulWord.DB.Repo

import_config "#{Mix.env()}.exs"
