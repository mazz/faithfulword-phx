defmodule FaithfulWord.Repo.Migrations.Admin do
  use Ecto.Migration

  def change do
    create table(:admin) do
      # add :id, :binary_id, primary_key: true
      add :name, :string
      add :email, :string
      add :encrypted_password, :string

      timestamps()
    end

    create index(:admin, [:email], unique: true)
  end
end
