defmodule Db.Repo.Migrations.AddHashIdToMediaItems do
  use Ecto.Migration
  import Ecto.Query
  alias Db.Schema.MediaItem

  def up do
    alter table(:mediaitems) do
      # A size of 10 allows us to go up to 100_000_000_000_000 media items
      add(:hash_id, :string, size: 12)
      add(:duration, :float, default: 0)
    end

    # Create unique index on hash_id
    create(unique_index(:mediaitems, [:hash_id]))

    # Flush pending migrations to ensure column is created
    flush()
  end

  def down do
    alter table(:mediaitems) do
      remove(:hash_id)
      remove(:duration)
    end
  end
end
