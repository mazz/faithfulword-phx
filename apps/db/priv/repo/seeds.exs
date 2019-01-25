# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DB.Repo.insert!(%FaithfulWord.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias DB.Repo
alias DB.Schema.User
require Logger

book =
  DB.Schema.Book.changeset(%DB.Schema.Book{}, %{
    absolute_id: 100,
    basename: "Genesis",
    uuid: Ecto.UUID.generate,
    chapter: %DB.Schema.Chapter{}
  })

  Repo.insert!(book)

Logger.debug("Application.get_env #{Application.get_env(:db, :env)}")
# Create Admin in dev or if we're running image locally
# if Application.get_env(:db, :env) == :dev do
# Logger.warn("API is running in dev mode. Inserting default user admin@faithfulword.app")

admin =
  User.registration_changeset(%User{reputation: 4200, username: "Jedediah"}, %{
    email: "admin@faithfulword.app",
    password: "password"
  })

Logger.debug("admin user inserted:")
IO.inspect(admin)
Repo.insert(admin)
# No need to warn if already exists
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Amos"}, %{
  email: "amos@faithfulword.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Peter"}, %{
  email: "peter@faithfulword.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Joseph"}, %{
  email: "joseph@faithfulword.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Adam"}, %{
  email: "adam@faithfulword.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "John"}, %{
  email: "john@faithfulword.app",
  password: "password"
}))
# end

