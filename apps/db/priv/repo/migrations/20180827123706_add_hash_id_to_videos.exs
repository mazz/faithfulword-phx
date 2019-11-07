defmodule Db.Repo.Migrations.AddHashIdToVideos do
  use Ecto.Migration
  import Ecto.Query
  alias Db.Schema.Video

  def up do
    alter table(:videos) do
      # A size of 10 allows us to go up to 100_000_000_000_000 videos
      add(:hash_id, :string, size: 12)
    end

    # Create unique index on hash_id
    create(unique_index(:videos, [:hash_id]))

    # Flush pending migrations to ensure column is created
    flush()

    # Update all existing videos with their hashIds

    # Db.Repo.all(from v in Video)
    # |> Enum.map(&Video.changeset_generate_hash_id/1)
    # |> Enum.map(&Db.Repo.update/1)
  end

  def down do
    alter table(:videos) do
      remove(:hash_id)
    end
  end
end
