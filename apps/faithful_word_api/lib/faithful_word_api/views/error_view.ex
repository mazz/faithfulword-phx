defmodule FaithfulWordApi.ErrorView do
  use FaithfulWordApi, :view

  require Logger
  alias FaithfulWord.Accounts.UserPermissions.PermissionsError

  def render("show.json", %{message: message}) do
    render_one(message, FaithfulWordApi.ErrorView, "error.json")
  end

  def render("401.json", _) do
    %{error: "unauthorized"}
  end

  def render("403.json", %{reason: %PermissionsError{message: message}}) do
    %{error: message}
  end

  def render("403.json", assigns) do
    Logger.debug(inspect(assigns))
    %{error: "forbidden"}
  end

  def render("404.json", _) do
    %{error: "not_found"}
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end

  def render("error.json", assigns) do
    Logger.debug(inspect(assigns))
    %{error: "unexpected"}
  end

  def render(_, assigns) do
    Logger.debug(inspect(assigns))
    %{error: "unexpected"}
  end
end
