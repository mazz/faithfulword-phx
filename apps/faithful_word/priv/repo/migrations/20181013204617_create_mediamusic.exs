defmodule FaithfulWord.DB.Repo.Migrations.CreateMediamusic do
  use Ecto.Migration

  def change do
    create table(:mediamusic) do

      add :absolute_id, :integer
      add :uuid, :uuid
      add :track_number, :integer
      add :localizedname, :string
      add :path, :string
      add :large_thumbnail_path, :string
      add :small_thumbnail_path, :string
      add :language_id, :string
      add :presenter_name, :string
      add :source_material, :string
      add :music_id, references(:music, on_delete: :nothing)

      timestamps()
    end

    create index(:mediamusic, [:music_id])
  end
end
