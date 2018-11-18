# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FaithfulWord.Repo.insert!(%FaithfulWord.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

FaithfulWord.Accounts.create_admin(%{
  email: "mazz@protonmail.com",
  name: "Michael Hanna"
})

FaithfulWord.Accounts.create_admin(%{
  email: "faithfulaudiodev@gmail.com",
  name: "FaithfulAudio Dev"
})
