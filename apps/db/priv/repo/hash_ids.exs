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
alias Db.Schema.MediaItem
alias Db.Schema.Playlist
alias Db.Schema.Channel
alias Db.Schema.Org
alias Db.Schema.Video

import Ecto.Query
require Logger

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

# No need to warn if already exists

# Update all existing mediaitems with their hashIds
Db.Repo.all(from mi in MediaItem)
|> Enum.map(&MediaItem.changeset_generate_hash_id/1)
|> Enum.map(&Db.Repo.update/1)

# Update all existing playlist with their hashIds
Db.Repo.all(from p in Playlist)
|> Enum.map(&Playlist.changeset_generate_hash_id/1)
|> Enum.map(&Db.Repo.update/1)

# Update all existing channel with their hashIds
Db.Repo.all(from c in Channel)
|> Enum.map(&Channel.changeset_generate_hash_id/1)
|> Enum.map(&Db.Repo.update/1)

Db.Repo.all(from o in Org)
|> Enum.map(&Org.changeset_generate_hash_id/1)
|> Enum.map(&Db.Repo.update/1)

Db.Repo.all(from v in Video)
|> Enum.map(&Video.changeset_generate_hash_id/1)
|> Enum.map(&Db.Repo.update/1)
