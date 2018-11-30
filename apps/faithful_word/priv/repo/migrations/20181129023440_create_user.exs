defmodule FaithfulWord.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION citext;")

    create table(:user) do
      add(:name, :string, null: false)
      add(:email, :citext, null: false)
      add(:password_hash, :string, null: false)

      timestamps()
    end

    create(unique_index(:user, [:email]))
  end
end
