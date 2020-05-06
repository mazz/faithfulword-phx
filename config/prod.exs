use Mix.Config

# faithful_word ###############################################################

config :faithful_word, Db.Repo, pool_size: 30

fw_domain = System.get_env("DOMAIN")
frontend_url = String.trim_trailing("https://webclient.#{fw_domain}") <> "/"

# frontend_url = String.trim_trailing("http://localhost:3000/") <> "/"

config :faithful_word,
  env: Mix.env(),
  ecto_repos: [Db.Repo],
  frontend_url: frontend_url

config :faithful_word, FaithfulWord.Mailer, adapter: Bamboo.MailgunAdapter

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

config :faithful_word_api, FaithfulWordApi.Endpoint,
  http: [:inet6, port: {:system, "FW_PORT"}],
  url: [host: "127.0.0.1", port: 4000],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  version: Application.spec(:faithful_word_api, :vsn)
  # code_reloader: false

# General #####################################################################

# Do not print debug messages in production
config :logger, level: :warn
