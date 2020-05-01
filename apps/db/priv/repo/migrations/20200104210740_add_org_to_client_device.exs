defmodule Db.Repo.Migrations.AddOrgToClientDevice do
  use Ecto.Migration

  def change do
    alter table(:clientdevices) do
      add :org_id, references(:orgs, on_delete: :delete_all)
      timestamps(type: :utc_datetime)
    end

    create index(:clientdevices, [:org_id])
    # flush()
  end
end
