# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Db.Repo.insert!(%FaithfulWord.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Db.Repo
alias Db.Schema.{User, Org}
require Logger
require Ecto.Query

# book =
#   Db.Schema.Book.changeset(%Db.Schema.Book{}, %{
#     absolute_id: 100,
#     basename: "Genesis",
#     uuid: Ecto.UUID.generate,
#     chapter: %Db.Schema.Chapter{}
#   })

#   Repo.insert!(book)

Logger.debug("Application.get_env #{Application.get_env(:db, :env)}")
# Create Admin in dev or if we're running image locally
# if Application.get_env(:db, :env) == :dev do
# Logger.warn("API is running in dev mode. Inserting default user admin@faithfulword.app")

# default_org = Org
# |> Repo.one!()

# Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "amos", name: "Amos", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "amos@faithfulword.app", password: "password"}))

# amos = %User{reputation: 4200, username: "amos", name: "Amos", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: faithfulwordapp.id, email: "amos@faithfulword.app", password: "password", encrypted_password: Bcrypt.hash_pwd_salt("password")}
# amos = Repo.insert!(amos)

# amos = %User{reputation: 4200, username: "amos", name: "Amos", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}
# amos_changeset = User.registration_changeset(amos, %{email: "amos@faithfulword.app", password: "password"})

# amos = %User{reputation: 4200, username: "amos", name: "Amos", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: faithfulwordapp.id, email: "amos@faithfulword.app", password: "password", encrypted_password: Bcrypt.hash_pwd_salt("password")}
# amos = Repo.insert!(amos)
# amos = User |> where([u], u.username == "amos" |> Repo.one()

amos_changeset = User.registration_changeset(%User{reputation: 4200, username: "amos", name: "Amos", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "amos@faithfulword.app", password: "password"})
Repo.insert(amos_changeset)
amos_query = Ecto.Query.from(u in User, where: u.username == "amos")
amos = Repo.one!(amos_query)

peter_changeset = User.registration_changeset(%User{reputation: 4200, username: "peter", name: "Peter", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "peter@faithfulword.app", password: "password"})
Repo.insert(peter_changeset)
peter_query = Ecto.Query.from(u in User, where: u.username == "peter")
peter = Repo.one!(peter_query)

joseph_changeset = User.registration_changeset(%User{reputation: 4200, username: "joseph", name: "Joseph", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "joseph@faithfulword.app", password: "password"})
Repo.insert(joseph_changeset)
joseph_query = Ecto.Query.from(u in User, where: u.username == "joseph")
joseph = Repo.one!(joseph_query)

adam_changeset = User.registration_changeset(%User{reputation: 4200, username: "adam", name: "Adam", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "adam@faithfulword.app", password: "password"})
Repo.insert(adam_changeset)
adam_query = Ecto.Query.from(u in User, where: u.username == "adam")
adam = Repo.one!(adam_query)

faithfulwordapp = Repo.get(Org, 1)
faithfulwordapp = Repo.preload(faithfulwordapp, [:channels, :users])
faithfulwordapp_changeset = Ecto.Changeset.change(faithfulwordapp)
faithfulwordapp_users_changeset = faithfulwordapp_changeset |> Ecto.Changeset.put_assoc(:users, [amos, peter, joseph, adam])

Repo.update!(faithfulwordapp_users_changeset)

jonathan_changeset = User.registration_changeset(%User{reputation: 4200, username: "jonathan", name: "Jonathan", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "jonathan@faithfulword.app", password: "password"})
Repo.insert(jonathan_changeset)
jonathan_query = Ecto.Query.from(u in User, where: u.username == "jonathan")
jonathan = Repo.one!(jonathan_query)

collin_changeset = User.registration_changeset(%User{reputation: 4200, username: "collin", name: "Collin", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "collin@faithfulword.app", password: "password"})
Repo.insert(collin_changeset)
collin_query = Ecto.Query.from(u in User, where: u.username == "collin")
collin = Repo.one!(collin_query)

mark_changeset = User.registration_changeset(%User{reputation: 4200, username: "mark", name: "Mark", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "mark@faithfulword.app", password: "password"})
Repo.insert(mark_changeset)
mark_query = Ecto.Query.from(u in User, where: u.username == "mark")
mark = Repo.one!(mark_query)

michael_changeset = User.registration_changeset(%User{reputation: 4200, username: "michael", name: "Michael", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "michael@faithfulword.app", password: "password"})
Repo.insert(michael_changeset)
michael_query = Ecto.Query.from(u in User, where: u.username == "michael")
michael = Repo.one!(michael_query)

fwbc = Repo.get(Org, 2)
fwbc = Repo.preload(fwbc, [:channels, :users])
fwbc_changeset = Ecto.Changeset.change(fwbc)
fwbc_users_changeset = fwbc_changeset |> Ecto.Changeset.put_assoc(:users, [jonathan, collin, mark, michael])

Repo.update!(fwbc_users_changeset)
