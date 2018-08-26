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

Olivetree.Users.create_admin(%{
  email: "user@olivetree",
  password: "123456",
  password_confirmation: "123456",
  name: "Dummy Admin"
})