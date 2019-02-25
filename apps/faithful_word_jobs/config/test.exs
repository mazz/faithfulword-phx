use Mix.Config

# Disable CRON tasks on test
config :faithful_word_jobs, FaithfulWord.Jobs.Scheduler, jobs: []
