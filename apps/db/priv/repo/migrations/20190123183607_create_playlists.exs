defmodule DB.Repo.Migrations.CreatePlaylists do
  use Ecto.Migration

  def change do
    create table(:playlists, primary_key: true) do

      add :ordinal, :integer
      add :uuid, :uuid
      add :basename, :string
      add :media_category, DB.Type.MediaCategory.type()
      # add :language_id, :string
      # add :localizedname, :string
      add :small_thumbnail_path, :string
      add :med_thumbnail_path, :string
      add :large_thumbnail_path, :string
      add :banner_path, :string
      add :channel_id, references(:channels, on_delete: :delete_all)
      add :multilanguage, :boolean, default: false
      timestamps(type: :utc_datetime)

      # timestamps()
    end

    create index(:playlists, [:channel_id])
    create index(:playlists, [:uuid])

    flush()
  end
end
