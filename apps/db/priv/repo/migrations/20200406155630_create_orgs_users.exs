defmodule Db.Repo.Migrations.CreateOrgsUsers do
  use Ecto.Migration

  def change do
    create table(:orgs_users) do
      add :org_id, references(:orgs)
      add :user_id, references(:users)
    end

    create unique_index(:orgs_users, [:org_id, :user_id])
  end
end
