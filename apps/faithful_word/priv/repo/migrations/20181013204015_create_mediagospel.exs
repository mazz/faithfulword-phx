defmodule FaithfulWord.Repo.Migrations.CreateMediagospel do
  use Ecto.Migration

  def change do
    create table(:mediagospel) do
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
      add :gospel_id, references(:gospel, on_delete: :nothing)

      # timestamps()
    end

    create index(:mediagospel, [:gospel_id])
  end
end
