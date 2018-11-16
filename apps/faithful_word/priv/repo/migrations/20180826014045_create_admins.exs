defmodule FaithfulWord.Repo.Migrations.CreateAdmins do
  use Ecto.Migration

  def change do
    create table(:admin) do
      add :email, :string
      add :name, :string

      timestamps()
    end

  end
end
