defmodule FaithfulWord.DB.Repo.Migrations.CreateMediaitems do
  use Ecto.Migration

  def change do
    create table(:mediaitems, primary_key: true) do

      add :ordinal, :integer
      add :uuid, :uuid
      add :track_number, :integer
      add :medium, :string
      add :localizedname, :string
      add :path, :string
      add :small_thumbnail_path, :string
      add :large_thumbnail_path, :string
      add :content_provider_link, :string
      add :ipfs_link, :string
      add :language_id, :string
      add :presenter_name, :string
      add :source_material, :string
      add :playlist_id, references(:playlists, on_delete: :delete_all)

      timestamps()
    end

    create index(:mediaitems, [:playlist_id])
  end
end
