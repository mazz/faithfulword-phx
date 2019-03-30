use Mix.Config

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
    {"*/1 * * * *", {FaithfulWord.Jobs.MetadataFetch, :update, []}},

  ]

# Configure Postgres pool size
config :db, DB.Repo, pool_size: 3

# Import environment specific config
import_config "#{Mix.env()}.exs"
