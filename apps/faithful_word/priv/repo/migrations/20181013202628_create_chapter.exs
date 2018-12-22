defmodule FaithfulWord.DB.Repo.Migrations.CreateChapter do
  use Ecto.Migration

  def change do
    create table(:chapter) do
      # add :id, :binary_id, primary_key: true
      add :absolute_id, :integer
      add :uuid, :uuid
      add :basename, :string
      add :book_id, references(:book, on_delete: :nothing)

      # timestamps()
    end

    create index(:chapter, [:book_id])
  end
end
