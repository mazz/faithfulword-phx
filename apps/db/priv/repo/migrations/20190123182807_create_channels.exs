defmodule DB.Repo.Migrations.CreateChannels do
  use Ecto.Migration

  def change do
    create table(:channels, primary_key: true) do

      add :uuid, :uuid
      add :ordinal, :integer
      add :basename, :string
      add :org_id, references(:orgs, on_delete: :delete_all)

      # timestamps()
    end

    create index(:channels, [:org_id])
  end
end
