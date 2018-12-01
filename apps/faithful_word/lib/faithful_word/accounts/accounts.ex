defmodule FaithfulWord.Accounts do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false

  alias FaithfulWord.Repo
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

    case check_password(user, password) do
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

  def auth_user(email, password) do
    user =
      User
      |> UserQuery.by_email(email)
      |> Repo.one()

    case User.check_password(user, password) do
      {:ok, user} -> {:ok, user}
      {:error, error} -> {:error, error}
    end
  end
end





