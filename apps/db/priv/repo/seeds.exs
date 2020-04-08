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

faithfulwordapp = Repo.get(Org, 1)

# Repo.insert(User.registration_changeset(%User{reputation: 4200, username: "amos", name: "Amos", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "amos@faithfulword.app", password: "password"}))

# amos = %User{reputation: 4200, username: "amos", name: "Amos", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: faithfulwordapp.id, email: "amos@faithfulword.app", password: "password", encrypted_password: Bcrypt.hash_pwd_salt("password")}
# amos = Repo.insert!(amos)

amos_changeset = User.registration_changeset(%User{reputation: 4200, username: "amos", name: "Amos", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}, %{email: "amos@faithfulword.app", password: "password"})
# amos = %User{reputation: 4200, username: "amos", name: "Amos", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: 1}
# amos_changeset = User.registration_changeset(amos, %{email: "amos@faithfulword.app", password: "password"})
Repo.insert(amos_changeset)

# amos = %User{reputation: 4200, username: "amos", name: "Amos", locale: "en", is_publisher: true, uuid: Ecto.UUID.generate(), org_id: faithfulwordapp.id, email: "amos@faithfulword.app", password: "password", encrypted_password: Bcrypt.hash_pwd_salt("password")}
# amos = Repo.insert!(amos)

# amos = User |> where([u], u.username == "amos" |> Repo.one()

amos_query = Ecto.Query.from(u in User,
    where: u.username == "amos")

amos = Repo.one!(amos_query)

faithfulwordapp = Repo.preload(faithfulwordapp, [:channels, :users])
faithfulwordapp_changeset = Ecto.Changeset.change(faithfulwordapp)
faithfulwordapp_users_changeset = faithfulwordapp_changeset |> Ecto.Changeset.put_assoc(:users, [amos])

Repo.update!(faithfulwordapp_users_changeset)

# No need to warn if already exists
# Repo.insert(
#   User.registration_changeset(
#     %User{
#       reputation: 4200,
#       username: "amos",
#       name: "Amos",
#       locale: "en",
#       is_publisher: true,
#       uuid: Ecto.UUID.generate(),
#       org_id: 1
#     },
#     %{
#       email: "amos@faithfulword.app",
#       password: "password"
#     }
#   )
# )

Repo.insert(
  User.registration_changeset(
    %User{
      reputation: 4200,
      username: "peter",
      name: "Peter",
      locale: "en",
      is_publisher: true,
      uuid: Ecto.UUID.generate(),
      org_id: 1
    },
    %{
      email: "peter@faithfulword.app",
      password: "password"
    }
  )
)

Repo.insert(
  User.registration_changeset(
    %User{
      reputation: 4200,
      username: "joseph",
      name: "Joseph",
      locale: "en",
      is_publisher: true,
      uuid: Ecto.UUID.generate(),
      org_id: 1
    },
    %{
      email: "joseph@faithfulword.app",
      password: "password"
    }
  )
)

Repo.insert(
  User.registration_changeset(
    %User{
      reputation: 4200,
      username: "adam",
      name: "Adam",
      locale: "en",
      is_publisher: true,
      uuid: Ecto.UUID.generate(),
      org_id: 1
    },
    %{
      email: "adam@faithfulword.app",
      password: "password"
    }
  )
)

Repo.insert(
  User.registration_changeset(
    %User{
      reputation: 4200,
      username: "jonathan",
      name: "Jonathan",
      locale: "en",
      is_publisher: true,
      uuid: Ecto.UUID.generate(),
      org_id: 1
    },
    %{
      email: "jonathan@faithfulword.app",
      password: "password"
    }
  )
)

Repo.insert(
  User.registration_changeset(
    %User{
      reputation: 4200,
      username: "collin",
      name: "Collin",
      locale: "en",
      is_publisher: true,
      uuid: Ecto.UUID.generate(),
      org_id: 1
    },
    %{
      email: "collin@faithfulword.app",
      password: "password"
    }
  )
)

Repo.insert(
  User.registration_changeset(
    %User{
      reputation: 4200,
      username: "michael",
      name: "Michael",
      locale: "en",
      is_publisher: true,
      uuid: Ecto.UUID.generate(),
      org_id: 1
    },
    %{
      email: "michael@faithfulword.app",
      password: "password"
    }
  )
)
