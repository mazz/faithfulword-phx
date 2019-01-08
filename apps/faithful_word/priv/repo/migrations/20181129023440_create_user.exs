defmodule FaithfulWord.DB.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    # execute("CREATE EXTENSION citext;")

    create table(:user) do
      add(:name, :string, null: false)
      add(:email, :citext, null: false)
      add(:password_hash, :string, null: false)
      # user confirmed via second auth factor i.e. email
      add(:confirmed, :boolean, default: false)
      # the user cannot log in if true

      add(:suspended, :boolean, default: false)

      timestamps()
    end

    create(unique_index(:user, [:email]))
  end
end
