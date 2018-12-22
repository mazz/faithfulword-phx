defmodule FaithfulWord.DB.Repo.Migrations.CreateMediachapter do
  use Ecto.Migration

  def change do
    create table(:mediachapter) do
      # add :id, :binary_id, primary_key: true
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
      add :chapter_id, references(:chapter, on_delete: :nothing)

      # timestamps()
    end

    create index(:mediachapter, [:chapter_id])
  end
end
