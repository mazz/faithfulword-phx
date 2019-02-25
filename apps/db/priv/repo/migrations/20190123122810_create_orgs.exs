defmodule DB.Repo.Migrations.CreateOrgs do
  use Ecto.Migration

  def change do
    create table(:orgs, primary_key: true) do

      add :uuid, :uuid
      add :small_thumbnail_path, :string
      add :med_thumbnail_path, :string
      add :large_thumbnail_path, :string
      add :banner_path, :string
      add :basename, :string
      timestamps(type: :utc_datetime)

      # timestamps()
    end

  end
end
