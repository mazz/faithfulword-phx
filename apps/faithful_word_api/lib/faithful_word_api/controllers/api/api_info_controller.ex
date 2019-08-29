defmodule FaithfulWordApi.ApiInfoController do
  use FaithfulWordApi, :controller

  def get(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{
      status: "✔",
      version: FaithfulWord.Application.version(),
      db_version: DB.Application.version()
    })
  end
end
