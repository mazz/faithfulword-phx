use Mix.Config

# Configure your database
config :db, DB.Repo,
  username: System.get_env("FW_DB_USERNAME") || "postgres",
  password: System.get_env("FW_DB_PASSWORD") || "postgres",
  database: "faithful_word_dev",
  hostname: "localhost"

# Configure file upload
config :arc, storage: Arc.Storage.Local, asset_host: "http://localhost:4000"
