defmodule FaithfulWord.Repo.Migrations.CreateMusictitle do
  use Ecto.Migration

  def change do
    create table(:musictitle) do
      # add :id, :binary_id, primary_key: true
      add :uuid, :uuid
      add :localizedname, :string
      add :language_id, :string
      add :music_id, references(:music, on_delete: :nothing)

      timestamps()
    end

    create index(:musictitle, [:music_id])
  end
end
