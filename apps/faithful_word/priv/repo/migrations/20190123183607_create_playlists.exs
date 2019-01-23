defmodule FaithfulWord.DB.Repo.Migrations.CreatePlaylists do
  use Ecto.Migration

  def change do
    create table(:playlists, primary_key: true) do

      add :ordinal, :integer
      add :uuid, :uuid
      add :localizedname, :string
      add :language_id, :string
      add :channel_id, references(:channels, on_delete: :delete_all)

      # timestamps()
    end

    create index(:playlists, [:channel_id])
  end
end
