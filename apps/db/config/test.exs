use Mix.Config

config :logger,
  level: :debug,
  backends: [:console],
  compile_time_purge_level: :debug

# Configure file upload
config :arc, storage: Arc.Storage.Local

# Configure your database
config :db, DB.Repo,
  hostname: "localhost",
  username: System.get_env("FW_DB_USERNAME") || "postgres",
  password: System.get_env("FW_DB_PASSWORD") || "postgres",
  database: "faithful_word_test",
  pool: Ecto.Adapters.SQL.Sandbox
