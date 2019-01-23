defmodule FaithfulWord.DB.Repo.Migrations.CreateMediaitemtags do
  use Ecto.Migration

  def change do
    create table(:mediaitemtags, primary_key: true) do
      add :uuid, :uuid
      add :tag_id, references(:tags, on_delete: :delete_all)
      add :mediaitem_id, references(:mediaitems, on_delete: :delete_all)

    end

    create index(:mediaitemtags, [:tag_id])
    create index(:mediaitemtags, [:mediaitem_id])
  end
end
