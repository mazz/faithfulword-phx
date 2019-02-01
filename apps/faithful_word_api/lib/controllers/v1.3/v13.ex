defmodule FaithfulWordApi.V13 do

  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Schema.{MediaChapter, Chapter, Book}
  alias DB.Schema.{BookTitle, LanguageIdentifier}

  alias DB.Schema.{MediaGospel, Gospel}
  alias DB.Schema.{GospelTitle, LanguageIdentifier}
  alias DB.Schema.{MusicTitle, Music, MediaMusic}
  alias DB.Schema.AppVersion
  alias DB.Schema.ClientDevice

  require Ecto.Query
  require Logger

  def books_by_language(language, offset \\ 0, limit \\ 0) do
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
          |> Repo.paginate(page: offset, page_size: limit)
          # |> DB.Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  def chapter_media_by_uuid(bid_str, language_id, offset \\ 0, limit \\ 0) do
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

  def gospel_by_language(language, offset \\ 0, limit \\ 0) do
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
          |> Repo.paginate(page: offset, page_size: limit)
          # |> Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  def gospel_media_by_uuid(gid_str, language_id, offset \\ 0, limit \\ 0) do
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
    # where: mg.language_id == ^language_id,
    where: mg.gospel_id == g.id,
    order_by: [mg.absolute_id, mg.id],
    # where: t.language_id  == ^language_id,
    select: %{localizedName: mg.localizedname, path: mg.path, presenterName: mg.presenter_name, sourceMaterial: mg.source_material, uuid: mg.uuid}

    query
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def music_by_language(language \\ "en", offset \\ 0, limit \\ 0) do
    # Ecto.Query.from(m in Music,
    # order_by: m.absolute_id,
    # select: %{mid: m.uuid, title: m.title})
    # |> Repo.paginate(page: offset, page_size: limit)

    languages = Ecto.Query.from(language in LanguageIdentifier,
    select: language.identifier)
    |> Repo.all

    Logger.debug("lang #{inspect %{attributes: languages}}")

    if !Enum.empty?(languages) do
      if Enum.find(languages, fn(_element) -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in MusicTitle,
          join: m in Music,
          on: title.music_id == m.id,
          where: title.language_id  == ^language,
          order_by: m.absolute_id,
          select: %{title: m.basename, localizedTitle: title.localizedname, uuid: m.uuid, languageId: title.language_id})
          |> Repo.paginate(page: offset, page_size: limit)
          # |> Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  def music_media_by_uuid(gid_str, language_id, offset \\ 0, limit \\ 0) do
    {:ok, gid_uuid} = Ecto.UUID.dump(gid_str)
    Logger.debug("gid_uuid: #{gid_uuid}")

    query = from m in Music,
    join: t in MusicTitle,
    # join: c in Chapter,
    join: mm in MediaMusic,

    where: m.uuid == ^gid_uuid,
    where: t.music_id == m.id,
    where: t.language_id  == ^language_id,
    # where: c.book_id == g.id,
    # where: c.id == mc.chapter_id,
    # where: mm.language_id == ^language_id,
    where: mm.music_id == m.id,
    order_by: [mm.absolute_id, mm.id],
    # where: t.language_id  == ^language_id,
    select: %{localizedName: mm.localizedname, path: mm.path, presenterName: mm.presenter_name, sourceMaterial: mm.source_material, uuid: mm.uuid}

    query
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def language_identifiers(offset \\ 0, limit \\ 0) do
    Ecto.Query.from(lid in LanguageIdentifier,
      order_by: lid.identifier,
      select: %{identifier: lid.identifier, source_material: lid.source_material, supported: lid.supported, uuid: lid.uuid})
      |> Repo.paginate(page: offset, page_size: limit)
  end

  def app_versions(offset \\ 0, limit \\ 0) do
    Ecto.Query.from(av in AppVersion,
      order_by: av.id,
      select: %{version_number: av.version_number,
      ios_supported: av.ios_supported,
      android_supported: av.android_supported,
      uuid: av.uuid})
      |> Repo.paginate(page: offset, page_size: limit)
  end

  def add_client_device(fcm_token, apns_token, preferred_language, user_agent, user_version) do
    case Repo.get_by(ClientDevice, firebase_token: fcm_token) do
      nil ->
        ClientDevice.changeset(%ClientDevice{}, %{
          apns_token: apns_token,
          firebase_token: fcm_token,
          preferred_language: preferred_language,
          user_agent: user_agent,
          user_version: user_version,
          uuid: Ecto.UUID.generate
        })
        |> Repo.insert()
      # client_device ->
      #   |> ClientDevice.changeset(%{
      #     apns_token: apns_token,
      #     firebase_token: fcm_token,
      #     preferred_language: preferred_language,
      #     user_agent: user_agent,
      #     user_version: user_version,
      #     uuid: uuid
      #   })
      #   |> Repo.update()
    end
  end
end
