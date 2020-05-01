defmodule FaithfulWordApi.ErrorView do
  use FaithfulWordApi, :view

  require Logger
  alias FaithfulWord.Accounts.UserPermissions.PermissionsError

  def render("show.json", %{message: message}) do
    render_one(message, FaithfulWordApi.ErrorView, "error.json")
  end

  def render("400.json", _) do
    %{error: "bad_request"}
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

  def render("500.json", assigns) do
    Logger.debug(inspect(assigns))
    %{error: "There was an error"}
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end

  def render("error.json", assigns) do
    Logger.debug(inspect(assigns))
    %{error: "There was an error -- error.json catchall"}
  end

  def render("400.html", _assigns) do
    render("400_page.html", %{})
  end

  def render("401.html", _assigns) do
    render("401_page.html", %{})
  end

  def render("403.html", _assigns) do
    render("403_page.html", %{})
  end

  def render("404.html", _assigns) do
    render("404_page.html", %{})
  end

  def render("500.html", _assigns) do
    render("500_page.html", %{})
  end


  # def render(_, assigns) do
  #   Logger.debug("second error.json")
  #   Logger.debug(inspect(assigns))
  #   %{error: "unexpected"}
  # end
end
