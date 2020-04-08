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

  #   Ecto.Query.from(org in Org,
  #   where: org.shortname == "faithfulwordapp",
  #   where: ^conditions,
  #   preload: [:channels],
  #   order_by: org.id,
  #   select: %{
  #     org: org
  #   }
  # )
  # |> Repo.paginate(page: offset, page_size: limit)

#   from(mi in MediaItem,
#   join: pl in Playlist,
#   where: mi.playlist_id == pl.id,
#   where: pl.uuid == ^playlist_uuid,
#   where: ^conditions
# )



# languages =
#   Ecto.Query.from(language in LanguageIdentifier,
#     select: language.identifier
#   )
#   |> Repo.all()

  # Ecto.Query.from(u in User,
  #   join: org in Org,
  #   join: ch in Channel,
  #   join: pl in Playlist,
  #   where: u.org_id == org.id,
  #   preload: []
  # )



    # user =
    #   User
    #   |> where([u], u.email == ^email_or_name or u.username == ^email_or_name)
    #   |> Repo.preload([orgs: :channels])

    user = Ecto.Query.from(u in User,
      where: u.email == ^email_or_name or u.username == ^email_or_name,
      preload: [orgs: :channels]
      )

    user = Repo.one!(user)
      # |> Repo.one()
      # |> Repo.preload(:orgs)
      # |> Repo.preload(:channels)

    # user = Repo.preload(user, :orgs)
    Logger.debug("user preload orgs: #{inspect(%{attributes: user})}")

    # orgs = user.orgs
    # Logger.debug("user.orgs: #{inspect(%{attributes: orgs})}")

    # orgs = Repo.preload(user.orgs, :channels)
    # Logger.debug("orgs preload channels: #{inspect(%{attributes: orgs})}")

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
