defmodule FaithfulWord.Repo do
  use Ecto.Repo,
    otp_app: :faithful_word,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    {:ok, Keyword.put(config, :url, System.get_env("DATABASE_URL"))}
  end
end
