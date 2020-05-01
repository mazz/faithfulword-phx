import Config

port = String.to_integer(System.fetch_env!("FW_PORT"))

# Database is configured in /apps/db/lib/db/repo

config :faithful_word,
  youtube_api_key: System.fetch_env!("FW_YOUTUBE_API_KEY"),
  oauth: [
    facebook: [
      client_id: System.fetch_env!("FW_FACEBOOK_CLIENT_ID"),
      client_secret: System.fetch_env!("FW_FACEBOOK_CLIENT_SECRET")
    ]
  ]

config :faithful_word, FaithfulWord.Authenticator.GuardianImpl,
  secret_key: System.fetch_env!("FW_GUARDIAN_SECRET_KEY")

config :faithful_word, FaithfulWord.Mailer,
  domain: System.fetch_env!("FW_MAILGUN_DOMAIN"),
  api_key: System.fetch_env!("FW_MAILGUN_API_KEY")

config :faithful_word_api, FaithfulWordApi.Endpoint,
  http: [port: port],
  url: [host: System.fetch_env!("FW_HOSTNAME"), port: port],
  secret_key_base: System.fetch_env!("FW_SECRET_KEY_BASE")

config :faithful_word_api, FaithfulWordApi.Guardian,
  secret_key: System.fetch_env!("FW_API_GUARDIAN_SECRET_KEY")

config :ex_aws,
  access_key_id: System.fetch_env!("FW_AWS_ACCESS_KEY_ID"),
  secret_access_key: System.fetch_env!("FW_AWS_SECRET_ACCESS_KEY")

config :rollbax,
  access_token: System.fetch_env!("FW_ROLBAX_ACCESS_TOKEN")

config :pigeon, :fcm,
  fcm_default: %{
    key: System.fetch_env!("FW_PIGEON_KEY")
  }

config :arc,
  bucket: System.fetch_env!("FW_ARC_S3_BUCKET")
