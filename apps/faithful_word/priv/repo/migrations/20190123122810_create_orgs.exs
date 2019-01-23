defmodule FaithfulWord.DB.Repo.Migrations.CreateOrgs do
  use Ecto.Migration

  def change do
    create table(:orgs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :uuid, :uuid
      add :basename, :string

      # timestamps()
    end

  end
end
