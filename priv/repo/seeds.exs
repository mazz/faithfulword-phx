# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Olivetree.Repo.insert!(%Olivetree.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Olivetree.Accounts.create_admin(%{
  email: "mazz@protonmail.com",
  name: "Michael Hanna"
})