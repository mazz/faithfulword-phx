defmodule FaithfulWordApi.AuthController do
  @moduledoc """
  Manages identity and third party authentication.
  """

  use FaithfulWordApi, :controller
  require Logger

  alias FaithfulWord.Authenticator
  alias FaithfulWord.Authenticator.GuardianImpl
  alias FaithfulWordApi.{ErrorView, UserView, AuthController}

  alias Kaur.Result

  plug(
    Guardian.Plug.EnsureAuthenticated,
    [handler: AuthController]
    when action in [:logout, :unlink_provider]
  )

  @err_authentication_failed "authentication_failed"
  @err_invalid_email_password "invalid_email_password"

  @doc """
  Auth with identity (name|email + password)
  """
  def callback(conn, %{"provider" => "identity", "email" => email, "password" => password}) do
    Logger.warn("email: #{email}")

    case Authenticator.get_user_for_email_or_name_password(email, password) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> put_view(ErrorView)
        |> render("error.json", message: @err_invalid_email_password)

      user ->
        signin_user(conn, user)
    end
  end

  @doc """
  Auth with third party provider (OAuth, only Facebook for now).
  If user is connected -> associate account with third party
  If not -> get or create account from third party infos
  """
  def callback(conn, params = %{"provider" => provider_str, "code" => code}) do
    user = GuardianImpl.Plug.current_resource(conn)
    provider = provider_atom!(provider_str)

    result =
      if user != nil do
        Authenticator.associate_user_with_third_party(user, provider, code)
      else
        Authenticator.get_user_by_third_party!(provider, code, params["invitation_token"])
      end

    case result do
      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> put_view(ErrorView)
        |> render("error.json", message: message)

      user ->
        signin_user(conn, user)
    end
  end

  @doc """
  Unlink given provider from user's account
  """
  def unlink_provider(conn, %{"provider" => provider_str}) do
    user = GuardianImpl.Plug.current_resource(conn)
    provider = provider_atom!(provider_str)

    Authenticator.dissociate_third_party(user, provider)
    |> Result.and_then(fn updated_user ->
      render(conn, UserView, :show, user: updated_user)
    end)
  end

  @doc """
  Logout user
  """
  def logout(conn, _params) do
    conn
    |> GuardianImpl.Plug.current_token()
    |> GuardianImpl.revoke()

    send_resp(conn, 204, "")
  end

  # Guardian methods: render errors on unauthenticated / unauthorized

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> put_view(ErrorView)
    |> render("401.json")
  end

  def unauthorized(conn, _params) do
    conn
    |> put_status(:forbidden)
    |> put_view(ErrorView)
    |> render("403.json")
  end

  # ---- Private ----

  # [!] Must be called ONLY if all verifications (password, third party...)
  # have already been made.
  # Render a user_with token `%{user, token}`
  defp signin_user(conn, user) do
    conn
    |> GuardianImpl.Plug.sign_in(user)
    |> GuardianImpl.Plug.current_token()
    |> case do
      nil ->
        conn
        |> put_status(:bad_request)
        |> put_view(ErrorView)
        |> render("error.json", message: @err_authentication_failed)

      token ->
        conn
        |> put_view(UserView)
        |> render("user_with_token.json", %{user: user, token: token})
    end
  end

  # Add supported providers here. If provider is not supported, it will raise
  defp provider_atom!("facebook"), do: :facebook
end
