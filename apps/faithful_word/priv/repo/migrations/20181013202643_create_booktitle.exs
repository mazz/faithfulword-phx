defmodule FaithfulWord.DB.Repo.Migrations.CreateBooktitle do
  use Ecto.Migration

  def change do
    create table(:booktitles) do
      # add :id, :binary_id, primary_key: true
      add :uuid, :uuid
      add :localizedname, :string
      add :language_id, :string
      add :book_id, references(:book, on_delete: :nothing)

      # timestamps()
    end

    create index(:booktitles, [:book_id])
  end
end
