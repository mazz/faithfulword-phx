defmodule Olivetree.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admins, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :string
      add :encrypted_password, :string
      add :name, :string
      add :password, :string
      add :password_confirmation, :string

      timestamps()
    end

  end
end
