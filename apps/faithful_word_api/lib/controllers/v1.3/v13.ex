defmodule FaithfulWordApi.V13 do

  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Schema.{MediaChapter, Chapter, Book}
  alias DB.Schema.{BookTitle, LanguageIdentifier}

  alias DB.Schema.{MediaGospel, Gospel}
  alias DB.Schema.{GospelTitle, LanguageIdentifier}

  require Ecto.Query
  require Logger

  def books_by_language(language) do
    languages = Ecto.Query.from(language in LanguageIdentifier,
      select: language.identifier)
      |> Repo.all

      Logger.debug("lang #{inspect %{attributes: languages}}")

    if !Enum.empty?(languages) do
      # python
      # localized_titles = dbsession.query(BookTitle, Book).join(Book).filter(BookTitle.language_id == language_id).order_by(Book.absolute_id.asc()).all()

      if Enum.find(languages, fn(_element) -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in DB.Schema.BookTitle,
          join: b in DB.Schema.Book,
          on: title.book_id == b.id,
          where: title.language_id  == ^language,
          order_by: b.absolute_id,
          select: %{title: b.basename, localizedTitle: title.localizedname, uuid: b.uuid, languageId: title.language_id})
          |> DB.Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  def chapter_media_by_bid(bid_str, language_id, offset \\ 0, limit \\ 0) do
    {:ok, bid_uuid} = Ecto.UUID.dump(bid_str)
    Logger.debug("bid_uuid: #{bid_uuid}")
    query = from b in Book,
    join: t in BookTitle,
    join: c in Chapter,
    join: mc in MediaChapter,

    where: b.uuid == ^bid_uuid,
    where: t.book_id == b.id,
    where: t.language_id  == ^language_id,
    where: c.book_id == b.id,
    where: c.id == mc.chapter_id,
    where: mc.language_id == ^language_id,
    order_by: [mc.absolute_id, mc.id],
    # where: t.language_id  == ^language_id,
    # where: mc.chapter_id == c.id,
    select: %{localizedName: mc.localizedname, path: mc.path, presenterName: mc.presenter_name, sourceMaterial: mc.source_material, uuid: mc.uuid}

    query
    |> Repo.paginate(page: offset, page_size: limit)
    # |> Repo.all
    # Repo.all
    # Repo.paginate(page: 1, page_size: 10)


    # Logger.debug("Repo.all(query):")
    # IO.inspect(Repo.all(query))
    # Repo.all(query)
  end

  def gospel_by_language(language) do
    languages = Ecto.Query.from(language in LanguageIdentifier,
      select: language.identifier)
      |> Repo.all

      Logger.debug("lang #{inspect %{attributes: languages}}")

    if !Enum.empty?(languages) do

      if Enum.find(languages, fn(_element) -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in GospelTitle,
          join: g in Gospel,
          on: title.gospel_id == g.id,
          where: title.language_id  == ^language,
          order_by: g.absolute_id,
          select: %{title: g.basename, localizedTitle: title.localizedname, uuid: g.uuid, languageId: title.language_id})
          |> Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  def gospel_media_by_gid(gid_str, language_id, offset \\ 0, limit \\ 0) do

    # (Ecto.Query.from book in Allscripture.Book
    #   |> join: title in Allscripture.BookTitle
    #   |> on: title.book_id == book.id
    #   |> where: title.language_id  == "pt"
    #   |> select: %{ uuid: book.uuid, language_id: title.language_id, title: book.basename, localized_title: title.localizedname }
    #   |> Allscripture.Repo.all)

    # (Ecto.Query
    # |> from g in Gospel
    # |> join: t in GospelTitle
    # |> join: mg in MediaGospel
    # |> where: g.uuid == ^gid_uuid
    # |> where: t.gospel_id == g.id
    # |> where: t.language_id  == ^language_id
    # |> where: mg.language_id == ^language_id
    # |> where: mg.gospel_id == g.id
    # |> order_by: [mg.absolute_id, mg.id]
    # |> select: %{localizedName: mg.localizedname, path: mg.path, presenterName: mg.presenter_name, sourceMaterial: mg.source_material, uuid: mg.uuid}
    # |> DB.Repo.all)

    {:ok, gid_uuid} = Ecto.UUID.dump(gid_str)
    Logger.debug("gid_uuid: #{gid_uuid}")


    query = from g in Gospel,
    join: t in GospelTitle,
    # join: c in Chapter,
    join: mg in MediaGospel,

    where: g.uuid == ^gid_uuid,
    where: t.gospel_id == g.id,
    where: t.language_id  == ^language_id,
    # where: c.book_id == g.id,
    # where: c.id == mc.chapter_id,
    where: mg.language_id == ^language_id,
    where: mg.gospel_id == g.id,
    order_by: [mg.absolute_id, mg.id],
    # where: t.language_id  == ^language_id,
    select: %{localizedName: mg.localizedname, path: mg.path, presenterName: mg.presenter_name, sourceMaterial: mg.source_material, uuid: mg.uuid}

    query
    |> Repo.paginate(page: offset, page_size: limit)
      # Repo.all
      # Repo.paginate(page: 1, page_size: 10)

    # Logger.debug("Repo.all(query):")
    # IO.inspect(Repo.all(query))
    # Repo.paginate(page: offset, page_size: limit)
  end
end
