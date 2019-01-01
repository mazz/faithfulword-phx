defmodule FaithfulWord.Accounts do
  @moduledoc """
  The Users context.
  """
  import Ecto.Query, warn: false
  require Logger

  alias Ecto.Multi
  alias FaithfulWord.DB.Repo
  alias FaithfulWord.DB.Type.Achievement
  alias FaithfulWord.DB.Schema.User
  alias FaithfulWord.DB.Schema.ResetPasswordRequest

  alias FaithfulWord.Mailer.Email
  alias FaithfulWord.Accounts.{UsernameGenerator, UserPermissions, Invitations}
  alias FaithfulWord.Actions.ActionCreator
  alias FaithfulWord.Authenticator

  alias Kaur.Result

  @max_ip_reset_requests 3
  # 48 hours
  @request_validity 48 * 60 * 60

  # Configure Fetching of user picture on adorable.io
  @fetch_default_picture Application.get_env(:faithful_word, :fetch_default_user_picture, true)

  # ---- User creation ----

  @doc """
  Create an account with given user `params`

  Returns {:ok, %User{}} if success
  In case of error, return can be :
    * {:error, %Ecto.Changeset{}}
    * {:error, message}
    * {:error, nil} (unknown error)
  """
  def create_account(_, _ \\ nil, _ \\ [])

  def create_account(user_params, invitation, opts) do
    unless Invitations.valid_invitation?(invitation) do
      {:error, "invalid_invitation_token"}
    else
      allow_empty_username = Keyword.get(opts, :allow_empty_username, false)
      provider_params = Keyword.get(opts, :provider_params, %{})

      # Do create user
      user_params
      |> prepare_user_params_from_third_party()
      |> create_account_from_params(provider_params, allow_empty_username)
      |> after_create(invitation)
    end
  end

  # Special formating for third-party provided user params
  defp prepare_user_params_from_third_party(params) do
    # Truncate name to avoid crashing when registering with a too-long name
    cond do
      Map.has_key?(params, :name) ->
        Map.update(params, :name, nil, &String.slice(&1, 0..19))

      Map.has_key?(params, "name") ->
        Map.update(params, "name", nil, &String.slice(&1, 0..19))

      true ->
        params
    end
  end

  defp create_account_from_params(user_params, provider_params, allow_empty_username) do
    case Map.get(user_params, "username") || Map.get(user_params, :username) do
      username when allow_empty_username and (is_nil(username) or username == "") ->
        email = Map.get(user_params, "email") || Map.get(user_params, :email)
        create_account_without_username(email, user_params, provider_params)

      _ ->
        do_create_account(user_params, provider_params)
    end
  end

  defp after_create(error = {:error, _}, _), do: error

  defp after_create(result = {:ok, user}, invitation_token) do
    # We willingly delete token using `invitation_token` string because we
    # accept having multiple invitations with the same token
    if invitation_token, do: Invitations.consume_invitation(invitation_token)

    # Send welcome mail or directly confirm email if third party provider
    if user.fb_user_id == nil do
      send_welcome(user)
    else
      confirm_email!(user)
    end

    if fetch_default_picture?() && user.picture_url == nil do
      Task.start(fn ->
        pic_url = FaithfulWord.DB.Type.UserPicture.default_url(:thumb, user)
        fetch_picture(user, pic_url)
      end)
    end

    # Return final result
    result
  end

  @doc """
  Update user
  """
  def update(user, params) do
    # TODO bang function name or unbang check
    UserPermissions.check!(user, :update, :user)
    changeset = User.changeset(user, params)

    Multi.new()
    |> Multi.update(:user, changeset)
    |> Multi.insert(:action, ActionCreator.action_update(user.id, changeset))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} ->
        {:ok, user}

      {:error, _, error, _} ->
        {:error, error}
    end
  end

  @doc """
  Delete User and its infos from DB
  Revoke and unlink every third parties authenticator accounts
  """
  @spec delete_account(%User{}) :: Kaur.Result.t()
  def delete_account(user = %User{}) do
    user
    |> Authenticator.dissociate_third_party(:facebook)
    |> Result.map(&Repo.delete(&1, []))
  end

  @doc """
  Send user a welcome email, with a link to confirm it (only if not already confirmed)
  """
  def send_welcome(%User{email_confirmed: true}), do: nil

  def send_welcome(user) do
    FaithfulWord.Mailer.deliver_later(FaithfulWord.Mailer.Email.welcome(user))
  end

  defp do_create_account(user_params, provider_params) do
    %User{}
    |> User.registration_changeset(user_params)
    |> User.provider_changeset(provider_params)
    |> Repo.insert()
  end

  defp create_account_without_username(nil, _, _), do: {:error, "invalid_email"}

  defp create_account_without_username(email, params, provider_params) do
    Multi.new()
    |> Multi.insert(
      :base_user,
      %User{username: temporary_username(email)}
      |> User.registration_changeset(Map.drop(params, [:username, "username"]))
      |> Ecto.Changeset.update_change(:achievements, fn list ->
        if Map.has_key?(provider_params, :fb_user_id),
          do: Enum.uniq([Achievement.get(:social_networks) | list]),
          else: list
      end)
      |> User.provider_changeset(provider_params)
    )
    |> Multi.run(:final_user, fn %{base_user: user} ->
      user
      |> User.changeset(%{})
      |> Ecto.Changeset.put_change(:username, UsernameGenerator.generate(user.id))
      |> Repo.update()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{final_user: user}} -> {:ok, user}
    end
  end

  defp temporary_username(email) do
    :crypto.hash(:sha256, email)
    |> Base.encode64()
    |> String.slice(-8..-2)
    |> (fn res -> "temporary-#{res}" end).()
  end

  # ---- Picture ----

  @doc """
  Fetch a user picture from given URL.

  Returns `{:ok, updated_user}` or `{:error, error}`
  """
  def fetch_picture(_, picture_url) when picture_url in [nil, ""],
    do: {:error, :invalid_path}

  def fetch_picture(user, picture_url) do
    # TODO config instead of matching env
    if Application.get_env(:faithful_word, :env) != :test do
      case FaithfulWord.DB.Type.UserPicture.store({picture_url, user}) do
        {:ok, picture} ->
          Repo.update(User.changeset_picture(user, picture))

        error ->
          error
      end
    else
      # Don't store files in tests
      Repo.update(User.changeset_picture(user, picture_url))
    end
  end

  # ---- Confirm email ----

  @doc """
  Confirm user email. Ignored if already confirmed.

  Returns updated user.
  """
  def confirm_email!(token) when is_binary(token),
    do: confirm_email!(Repo.get_by(User, email_confirmation_token: token))

  def confirm_email!(user = %User{email_confirmed: true}),
    do: user

  def confirm_email!(user = %User{email_confirmed: false}) do
    Multi.new()
    |> Multi.update(:user, User.changeset_confirm_email(user, true))
    |> Multi.insert(:action, ActionCreator.action_email_confirmed(user.id))
    |> Repo.transaction()
    |> case do
      {:ok, %{user: updated_user}} ->
        case unlock_achievement(updated_user, :not_a_robot) do
          {:ok, final_user} ->
            final_user

          # Don't fail if achievement cannot be unlocked, but log the error
          _ ->
            Logger.error(":not_a_robot achievement unlock failed for user #{user.id}")
            updated_user
        end

      {:error, _, reason, _} ->
        Logger.error(reason)
        raise reason
    end
  end

  # ---- Achievements -----

  @doc """
  Unlock given achievement. `achievement` can be passed as an integer or as the
  atom representation. See `DB.Type.Achievement` for more info.
  """
  def unlock_achievement(user, achievement) when is_atom(achievement),
    do: unlock_achievement(user, Achievement.get(achievement))

  def unlock_achievement(user, achievement) when is_integer(achievement) do
    if achievement in user.achievements do
      # Don't update user if achievement is already unlocked
      {:ok, user}
    else
      Repo.transaction(fn ->
        user
        |> lock_user()
        |> User.changeset_achievement(achievement)
        |> Repo.update!()
      end)
    end
  end

  # ---- Onboarding Steps ----

  @doc """
  add the given `step` to `user`

  Returns `{:ok, updated_user}` or `{:error, reason}`.
  """
  @spec complete_onboarding_step(%User{}, integer) :: {:ok, %User{}} | {:error, any}
  def complete_onboarding_step(user = %User{}, step)
      when is_integer(step) do
    user
    |> User.changeset_completed_onboarding_steps(step)
    |> Repo.update()
  end

  @doc """
  add the given `steps` to `user`

  Returns `{:ok, updated_user}` or `{:error, changeset}
  """
  @spec complete_onboarding_steps(%User{}, list) :: {:ok, %User{}} | {:error, Ecto.Changeset.t()}
  def complete_onboarding_steps(user = %User{}, steps)
      when is_list(steps) do
    user
    |> User.changeset_completed_onboarding_steps(steps)
    |> Repo.update()
  end

  @doc """
  reinitialize onboarding steps for `user`

  Returns `{:ok, updated_user}` or `{:error, reason}`.
  """
  def delete_onboarding(user = %User{}) do
    user
    |> User.changeset_delete_onboarding()
    |> Repo.update()
  end

  # ---- Link speaker ----

  @doc """
  Link a speaker to given user.
  """
  def link_speaker(user, speaker) do
    user
    |> User.changeset_link_speaker(speaker)
    |> Repo.update()
  end

  # ---- Reputation ----

  @doc """
  Update user retutation with `user.reputation + diff`. Properly lock user in DB
  to ensure no cheating can be made.
  """
  def update_reputation(user, diff) when is_integer(diff) do
    Repo.transaction(fn ->
      user
      |> lock_user()
      |> User.reputation_changeset(diff)
      |> Repo.update!()
    end)
  end

  # ---- Reset Password ----

  @doc """
  Returns the user associated with given reset password token
  """
  def reset_password!(email, source_ip_address) when is_binary(source_ip_address) do
    user = Repo.get_by!(User, email: email)

    # Ensure not flooding
    nb_ip_requests =
      ResetPasswordRequest
      |> where([r], r.source_ip == ^source_ip_address)
      |> Repo.aggregate(:count, :token)

    if nb_ip_requests > @max_ip_reset_requests do
      raise %UserPermissions.PermissionsError{message: "limit_reached"}
    end

    # Generate request
    request =
      %ResetPasswordRequest{}
      |> ResetPasswordRequest.changeset(%{user_id: user.id, source_ip: source_ip_address})
      |> Repo.insert!()

    # Email request
    request
    |> Map.put(:user, user)
    |> Email.reset_password_request()
    |> FaithfulWord.Mailer.deliver_later()
  end

  @doc """
  Returns the user associated with given reset password token or raise
  """
  def check_reset_password_token!(token) do
    date_limit =
      DateTime.utc_now()
      |> DateTime.to_naive()
      |> NaiveDateTime.add(-@request_validity, :second)

    User
    |> join(:inner, [u], r in ResetPasswordRequest, r.user_id == u.id)
    |> where([u, r], r.token == ^token)
    |> where([u, r], r.inserted_at >= ^date_limit)
    |> Repo.one!()
  end

  @doc """
  Changes user password
  """
  def confirm_password_reset!(token, new_password) do
    updated_user =
      token
      |> check_reset_password_token!()
      |> User.password_changeset(%{password: new_password})
      |> Repo.update!()

    Repo.delete_all(from(r in ResetPasswordRequest, where: r.user_id == ^updated_user.id))
    updated_user
  end

  # ---- Newsletter ----

  def send_newsletter(subject, html_body, locale_filter \\ nil) do
    User
    |> filter_newsletter_targets(locale_filter)
    |> Repo.all()
    |> Enum.map(&FaithfulWord.Mailer.Email.newsletter(&1, subject, html_body))
    |> Enum.map(&FaithfulWord.Mailer.deliver_later/1)
    |> Enum.count()
  end

  defp filter_newsletter_targets(query, nil), do: where(query, [u], u.newsletter == true)

  defp filter_newsletter_targets(query, locale),
    do: where(query, [u], u.newsletter == true and u.locale == ^locale)

  # ---- Getters ----

  def fetch_default_picture?, do: @fetch_default_picture

  # ---- Private Utils ----

  defp lock_user(%User{id: id}), do: lock_user(id)

  defp lock_user(user_id) do
    User
    |> where(id: ^user_id)
    |> lock("FOR UPDATE")
    |> Repo.one!()
  end



#
#
#
#
# DEPRECATED ################################################################################
#
#
#
#
import Ecto.Query, warn: false

alias FaithfulWord.DB.Repo
alias FaithfulWord.Accounts.Queries.Admin, as: AdminQuery
alias FaithfulWord.Accounts.Queries.User, as: UserQuery
alias FaithfulWord.Accounts.Admin
alias FaithfulWord.Accounts.User



  @doc """
  Returns the list of admins.

  ## Examples

      iex> list_admins()
      [%Admin{}, ...]

  """
  def list_admins do
    Repo.all(Admin)
  end

  @doc """
  Gets a single admin by id.

  Raises `Ecto.NoResultsError` if the Admin does not exist.

  ## Examples

      iex> get_admin_by_id!(123)
      %Admin{}

      iex> get_admin_by_id!(456)
      ** (Ecto.NoResultsError)

  """
  def get_admin_by_id!(id) do
    Admin
    |> AdminQuery.by_id(id)
    |> Repo.one!()
  end

  @doc """
  Gets a single admin by id.

  Returns `nil` if the Admin does not exist.

  ## Examples

      iex> get_admin_by_id(123)
      %Admin{}

      iex> get_admin_by_id(456)
      nil

  """
  def get_admin_by_id(id) do
    Admin
    |> AdminQuery.by_id(id)
    |> Repo.one()
  end

  @doc """
  Gets a single admin by email.

  Raises `Ecto.NoResultsError` if the Admin does not exist.

  ## Examples

      iex> get_admin_by_email!(admin@elixirjobs.net)
      %Admin{}

      iex> get_admin_by_email!(wadus@gmail.com)
      ** (Ecto.NoResultsError)

  """
  def get_admin_by_email!(email) do
    Admin
    |> AdminQuery.by_email(email)
    |> Repo.one!()
  end

  def get_or_create_by_email(email) do
    case Repo.get_by(Admin, email: email) do
      nil ->
        create_admin(%{email: email, name: "New User"})

      admin ->
        {:ok, admin}
    end
  end


  @doc """
  Gets a single admin by email.

  Raises `Ecto.NoResultsError` if the Admin does not exist.

  ## Examples

      iex> auth_admin!("admin@elixirjobs.net", "123456")
      {:ok, %Admin{}}

      iex> auth_admin!("admin@elixirjobs.net", "wrong_password")
      {:error, :wrong_credentials}

      iex> auth_admin!("non-admin@elixirjobs.net", "password")
      {:error, :wrong_credentials}

  """
  def auth_admin(email, password) do
    admin =
      Admin
      |> AdminQuery.by_email(email)
      |> Repo.one()

    case Admin.check_password(admin, password) do
      {:ok, admin} -> {:ok, admin}
      {:error, error} -> {:error, error}
    end
  end

  @doc """
  Creates a admin.

  ## Examples

      iex> create_admin(%{field: value})
      {:ok, %Admin{}}

      iex> create_admin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_admin(attrs \\ %{}) do
    %Admin{}
    |> Admin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a admin.

  ## Examples

      iex> update_admin(admin, %{field: new_value})
      {:ok, %Admin{}}

      iex> update_admin(admin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_admin(%Admin{} = admin, attrs) do
    admin
    |> Admin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Admin.

  ## Examples

      iex> delete_admin(admin)
      {:ok, %Admin{}}

      iex> delete_admin(admin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_admin(%Admin{} = admin) do
    Repo.delete(admin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking admin changes.

  ## Examples

      iex> change_admin(admin)
      %Ecto.Changeset{source: %Admin{}}

  """
  def change_admin(%Admin{} = admin) do
    Admin.changeset(admin, %{})
  end

  @doc """
  Returns an array of tuples with {%Admin{name}, %Admin{email}} to be used on email sending

  ## Examples

    iex> admin_emails
    {"admin_name", "admin_email"}
  """

  def admin_emails do
    Admin
    |> AdminQuery.only_admin_emails()
    |> Repo.all()
  end

  alias FaithfulWord.Accounts.User

  def authenticate(email, password) do
    user = Repo.get_by(User, email: String.downcase(email))

    case check_password(user, password) &&
      check_suspended(user) &&
      check_confirmed(user) do
      true -> {:ok, user}
      _ -> :error
    end
  end

  defp check_password(user, password) do
    case user do
      nil -> Comeonin.Argon2.dummy_checkpw()
      _ -> Comeonin.Argon2.checkpw(password, user.password_hash)
    end
  end

  def check_suspended(user) do
    case user.suspended == false do
      true -> true
      _ -> false
    end
  end

  def check_confirmed(user) do
    case user.confirmed == true do
      true -> true
      _ -> false
    end
  end

  @doc """
  Returns the list of user.

  ## Examples

      iex> list_user()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    result =
      %User{}
      |> User.registration_changeset(attrs)
      |> Repo.insert()

    case result do
      {:ok, user} -> {:ok, %User{user | password: nil}}
      _ -> result
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def get_user_by_id(id) do
    User
    |> UserQuery.by_id(id)
    |> Repo.one()
  end

  # def auth_user(email, password) do
  #   user =
  #     User
  #     |> UserQuery.by_email(email)
  #     |> Repo.one()

  #   case User.check_password(user, password) do
  #     {:ok, user} -> {:ok, user}
  #     {:error, error} -> {:error, error}
  #   end
  # end

  def get_user_by_email!(email) do
    User
    |> UserQuery.by_email(email)
    |> Repo.one!()
  end

end





