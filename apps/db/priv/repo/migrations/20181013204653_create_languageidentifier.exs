defmodule Db.Repo.Migrations.CreateLanguageidentifier do
  use Ecto.Migration

  def change do
    create table(:languageidentifiers) do
      add :uuid, :uuid
      add :identifier, :string
      add :source_material, :string
      add :supported, :boolean, default: false, null: false

      # timestamps()
    end

    create index(:languageidentifiers, [:uuid])
  end
end
