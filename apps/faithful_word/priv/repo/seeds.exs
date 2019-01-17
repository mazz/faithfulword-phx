# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FaithfulWord.DB.Repo.insert!(%FaithfulWord.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias FaithfulWord.DB.Repo
alias FaithfulWord.DB.Schema.User
require Logger

book =
  FaithfulWord.Content.Book.changeset(%FaithfulWord.Content.Book{}, %{
    absolute_id: 100,
    basename: "Genesis",
    uuid: Ecto.UUID.generate,
    chapter: %FaithfulWord.Content.Chapter{}
  })

  Repo.insert!(book)

Logger.debug("Application.get_env #{Application.get_env(:faithful_word, :env)}")
# Create Admin in dev or if we're running image locally
# if Application.get_env(:faithful_word, :env) == :dev do
# Logger.warn("API is running in dev mode. Inserting default user admin@faithfulword.app")

admin =
  User.registration_changeset(%User{reputation: 4200, username: "Jedediah"}, %{
    email: "admin@faithfulword.app",
    password: "password"
  })

Logger.debug("admin user inserted:")
IO.inspect(admin)

# No need to warn if already exists
Repo.insert(admin)
# end

