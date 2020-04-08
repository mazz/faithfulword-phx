defmodule FaithfulWord.Authenticator do
  @moduledoc """
  Handle all authentication intelligence
  """
  import Ecto.Query

  alias Db.Repo
  alias Db.Schema.User
  alias FaithfulWord.Authenticator.ProviderInfos
  alias FaithfulWord.Authenticator.OAuth
  alias Kaur.Result

  require Logger

  @doc """
  Get user from its email address or user name and check password.
  Returns nil if no User for email or if password is invalid.
  """
  def get_user_for_email_or_name_password(email_or_name, password) do

    # swipe 2
    user = Repo.one from user in User,
      where: user.email == ^email_or_name or user.username == ^email_or_name,
      left_join: orgs in assoc(user, :orgs),
      left_join: channels in assoc(orgs, :channels),
      preload: [orgs: {orgs, channels: channels}]

      Logger.debug("user preload orgs channels: #{inspect(%{attributes: user})}")

    with user when not is_nil(user) <- user,
         true <- validate_pass(user.encrypted_password, password) do
      user
    else
      _ -> nil
    end
  end

  @doc """
  Get a user from third party info, creating it if necessary
  """
  def get_user_by_third_party!(provider, code, invitation_token \\ nil) do
    case OAuth.fetch_user_from_third_party(provider, code) do
      provider_infos = %ProviderInfos{} ->
        OAuth.find_or_create_user!(provider_infos, invitation_token)

      error ->
        error
    end
  end

  @doc """
  Associate a third party account with an existing FaithfulWord account
  """
  def associate_user_with_third_party(user, provider, code) do
    case OAuth.fetch_user_from_third_party(provider, code) do
      provider_infos = %ProviderInfos{} ->
        OAuth.link_provider!(user, provider_infos)

      error ->
        error
    end
  end

  @doc """
  Dissociate given third party from user's account
  """
  @spec dissociate_third_party(%User{}, %ProviderInfos{}) :: Result.t()
  def dissociate_third_party(user, provider) do
    OAuth.unlink_provider(user, provider)
  end

  defp validate_pass(_encrypted, password) when password in [nil, ""],
    do: false

  defp validate_pass(encrypted, password),
    do: Bcrypt.verify_pass(password, encrypted)
end
