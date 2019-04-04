defmodule FaithfulWord.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Misc workers
      worker(FaithfulWord.Accounts.UsernameGenerator, []),
      # Sweep tokens from db
      worker(Guardian.DB.Token.SweeperServer, [])
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: FaithfulWord.Supervisor)
  end

  def version() do
    case :application.get_key(:faithful_word, :vsn) do
      {:ok, version} -> to_string(version)
      _ -> "unknown"
    end
  end

  @doc """
  If Mix is available, returns Mix.env(). If not available (in releases) return :prod
  """
  @deprecated "use Application.get_env(:faithful_word, :env)"
  def env() do
    (Kernel.function_exported?(Mix, :env, 0) && Mix.env()) || :prod
  end
end
