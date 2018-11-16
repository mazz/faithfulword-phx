defmodule FaithfulWord.Repo.Migrations.Admin do
  use Ecto.Migration

  def change do
    create table(:admin) do
      # add :id, :binary_id, primary_key: true
      add :email, :string
      add :name, :string

      timestamps()
    end
  end
end
