defmodule FaithfulWord.Jobs.Application do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Scheduler for all CRON jobs
      worker(FaithfulWord.Jobs.Scheduler, []),
      # Jobs
      worker(FaithfulWord.Jobs.Reputation, []),
      worker(FaithfulWord.Jobs.Flags, []),
      worker(FaithfulWord.Jobs.Moderation, [])
    ]

    opts = [strategy: :one_for_one, name: FaithfulWord.Jobs.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Get app's version from `mix.exs`
  """
  def version() do
    case :application.get_key(:faithful_word, :vsn) do
      {:ok, version} -> to_string(version)
      _ -> "unknown"
    end
  end
end
