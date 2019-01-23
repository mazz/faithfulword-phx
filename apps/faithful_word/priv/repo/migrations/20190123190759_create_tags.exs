defmodule FaithfulWord.DB.Repo.Migrations.CreateTags do
  use Ecto.Migration

  def change do
    create table(:tags, primary_key: true) do
      add :uuid, :uuid
      add :basename, :string
      add :description, :string

      # timestamps()
    end

  end
end
