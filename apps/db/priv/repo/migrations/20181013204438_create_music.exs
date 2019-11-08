defmodule Db.Repo.Migrations.CreateMusic do
  use Ecto.Migration

  def change do
    create table(:music) do
      add :absolute_id, :integer
      add :uuid, :uuid
      add :basename, :string
      timestamps(type: :utc_datetime)

      # timestamps()
    end

    create index(:music, [:uuid])
  end
end
