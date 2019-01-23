defmodule FaithfulWord.API.V13 do

  import Ecto.Query, warn: false
  alias FaithfulWord.DB.Repo
  alias FaithfulWord.DB.Schema.Book
  alias FaithfulWord.DB.Schema.LanguageIdentifier

  require Ecto.Query
  require Logger

  def books_by_language(language) do
    languages = Ecto.Query.from(language in LanguageIdentifier,
      select: language.identifier)
      |> Repo.all

      Logger.debug("lang #{inspect %{attributes: languages}}")

    if !Enum.empty?(languages) do

      if Enum.find(languages, fn(_element) -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in FaithfulWord.DB.Schema.BookTitle,
          join: b in FaithfulWord.DB.Schema.Book,
          on: title.book_id == b.id,
          where: title.language_id  == ^language,
          order_by: b.absolute_id,
          select: %{title: b.basename, localizedTitle: title.localizedname, uuid: b.uuid, languageId: title.language_id})
          |> FaithfulWord.DB.Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  def version() do
    "1.3"
  end
end
