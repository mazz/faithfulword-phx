defmodule Db.Repo.Migrations.CreateBooktitle do
  use Ecto.Migration

  def change do
    create table(:booktitles) do
      add :uuid, :uuid
      add :localizedname, :string
      add :language_id, :string
      add :book_id, references(:books, on_delete: :nothing)

      # timestamps()
    end

    create index(:booktitles, [:book_id])
    create index(:booktitles, [:uuid])
  end
end
