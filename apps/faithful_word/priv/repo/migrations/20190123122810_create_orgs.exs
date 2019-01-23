defmodule FaithfulWord.DB.Repo.Migrations.CreateOrgs do
  use Ecto.Migration

  def change do
    create table(:orgs, primary_key: true) do

      add :uuid, :uuid
      add :basename, :string

      # timestamps()
    end

  end
end
