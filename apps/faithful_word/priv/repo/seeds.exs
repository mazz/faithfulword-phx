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

FaithfulWord.Accounts.create_admin(%{
  email: "mazz@protonmail.com",
  password: "12345678",
  password_confirmation: "12345678",
  name: "Michael Hanna"
})

FaithfulWord.Accounts.create_admin(%{
  email: "faithfulaudiodev@gmail.com",
  password: "12345678",
  password_confirmation: "12345678",
  name: "FaithfulAudio Dev"
})

user =
  FaithfulWord.Accounts.User.registration_changeset(%FaithfulWord.Accounts.User{}, %{
    name: "Michael Hanna",
    email: "michael@faithfulword.app",
    password: "12345678"
  })

book =
  FaithfulWord.Content.Book.changeset(%FaithfulWord.Content.Book{}, %{
    absolute_id: 100,
    basename: "Genesis",
    uuid: Ecto.UUID.generate,
    chapter: %FaithfulWord.Content.Chapter{}
  })

  FaithfulWord.DB.Repo.insert!(user)
  FaithfulWord.DB.Repo.insert!(book)
