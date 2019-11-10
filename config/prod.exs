use Mix.Config

# faithful_word ###############################################################

config :faithful_word, Db.Repo, pool_size: 30

frontend_url = String.trim_trailing("http://localhost:3000/") <> "/"

config :faithful_word,
  env: Mix.env(),
  ecto_repos: [Db.Repo],
  frontend_url: frontend_url

config :faithful_word, FaithfulWord.Mailer,
  adapter: Bamboo.MailgunAdapter

config :faithful_word, FaithfulWord.Authenticator.GuardianImpl,
  issuer: "FaithfulWord",
  ttl: {30, :days},
  serializer: FaithfulWord.Accounts.GuardianSerializer,
  permissions: %{default: [:read, :write]}

config :faithful_word,
  captions_fetcher: FaithfulWord.Videos.CaptionsFetcherYoutube

config :guardian, Guardian.DB, repo: Db.Repo

# faithful_word_api ###########################################################

config :phoenix, :serve_endpoints, true

# General #####################################################################

# Do not print debug messages in production
config :logger, level: :warn
