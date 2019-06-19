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

# book =
#   DB.Schema.Book.changeset(%DB.Schema.Book{}, %{
#     absolute_id: 100,
#     basename: "Genesis",
#     uuid: Ecto.UUID.generate,
#     chapter: %DB.Schema.Chapter{}
#   })

#   Repo.insert!(book)

Logger.debug("Application.get_env #{Application.get_env(:db, :env)}")
# Create Admin in dev or if we're running image locally
# if Application.get_env(:db, :env) == :dev do
# Logger.warn("API is running in dev mode. Inserting default user admin@faithfulword.app")

# No need to warn if already exists
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Amos", is_publisher: true, uuid: Ecto.UUID.generate, org_id: 1}, %{
  email: "amos@faithfulword.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Peter", is_publisher: true, uuid: Ecto.UUID.generate, org_id: 1}, %{
  email: "peter@faithfulword.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Joseph", is_publisher: true, uuid: Ecto.UUID.generate, org_id: 1}, %{
  email: "joseph@faithfulword.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Adam", is_publisher: true, uuid: Ecto.UUID.generate, org_id: 1}, %{
  email: "adam@faithfulword.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Jonathan", is_publisher: true, uuid: Ecto.UUID.generate, org_id: 1}, %{
  email: "jonathan@faithfulword.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Collin", is_publisher: true, uuid: Ecto.UUID.generate, org_id: 1}, %{
  email: "collin@faithfulword.app",
  password: "password"
}))
Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "Michael", is_publisher: true, uuid: Ecto.UUID.generate, org_id: 1}, %{
  email: "michael@faithfulword.app",
  password: "password"
}))

