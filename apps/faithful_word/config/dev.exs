# Since configuration is shared in umbrella projects, this file
# should only configure the :faithful_word application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :faithful_word, FaithfulWord.Repo,
  database: "faithful_word_dev",
  pool_size: 10
