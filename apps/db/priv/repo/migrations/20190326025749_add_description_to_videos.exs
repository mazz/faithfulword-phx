defmodule DB.Repo.Migrations.AddDescriptionToVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :description, :text
      add :channelTitle, :string
      add :publishedAt, :utc_datetime
      add :tags, {:array, :string}
    end

    alter table(:mediaitems) do
      add :media_category, DB.Type.MediaCategory.type()
      add :presented_at, :utc_datetime, null: true
    end

    alter table(:orgs) do
      add :shortname, :string
    end

    # create(unique_index(:videos, [:tags]))
  end
end
