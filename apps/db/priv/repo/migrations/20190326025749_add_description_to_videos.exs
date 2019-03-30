defmodule DB.Repo.Migrations.AddDescriptionToVideos do
  use Ecto.Migration

  def change do
    alter table(:videos) do
      add :description, :text
      add :channelTitle, :string
      add :publishedAt, :utc_datetime
      add :tags, {:array, :string}
    end
    # create(unique_index(:videos, [:tags]))
  end
end
