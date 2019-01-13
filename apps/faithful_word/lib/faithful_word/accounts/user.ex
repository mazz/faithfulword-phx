defmodule FaithfulWord.Accounts.User do
#
#
#
#
# DEPRECATED ################################################################################
#
#
#
#

use Ecto.Schema
  import Ecto.Changeset
  alias FaithfulWord.Accounts.User

  schema "user" do
    field(:email, :string)
    field(:name, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)
    # user confirmed via second auth factor i.e. email
    field(:confirmed, :boolean, default: false)
    # the user cannot log in if true
    field(:suspended, :boolean, default: false)

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_length(:name, min: 2, max: 255)
    |> validate_length(:email, min: 5, max: 255)
    |> unique_constraint(:email)
    |> validate_format(:email, ~r/@/)
  end

  def registration_changeset(%User{} = user, attrs) do
    user
    |> changeset(attrs)
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 100)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Argon2.hashpwsalt(password))

      _ ->
        changeset
    end
  end

  def check_password(%User{} = user, password) do
    case Comeonin.Argon2.checkpw(password, user.password_hash) do
      true -> {:ok, user}
      _ -> {:error, :wrong_credentials}
    end
  end

  def check_password(_, _) do
    Comeonin.Argon2.dummy_checkpw()
    {:error, :wrong_credentials}
  end

end