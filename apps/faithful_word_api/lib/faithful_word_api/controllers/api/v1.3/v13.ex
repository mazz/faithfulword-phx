defmodule FaithfulWordApi.V13 do

  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Schema.{MediaChapter, Chapter, Book}
  alias DB.Schema.{BookTitle, LanguageIdentifier}

  alias DB.Schema.{MediaGospel, Gospel}
  alias DB.Schema.{GospelTitle, LanguageIdentifier}
  alias DB.Schema.{MusicTitle, Music, MediaMusic}
  alias DB.Schema.{Org, Channel, Playlist, PlaylistTitle, MediaItem}
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

  def gospel_media_by_uuid(gid_str, offset \\ 0, limit \\ 0) do
    {:ok, gid_uuid} = Ecto.UUID.dump(gid_str)
    Logger.debug("gid_uuid: #{gid_uuid}")


    query = from g in Gospel,
    # join: t in GospelTitle,
    # join: c in Chapter,
    join: mg in MediaGospel,

    where: g.uuid == ^gid_uuid,
    # where: t.gospel_id == g.id,
    # where: t.language_id  == ^language_id,
    # where: c.book_id == g.id,
    # where: c.id == mc.chapter_id,
    # where: mg.language_id == ^language_id,
    where: mg.gospel_id == g.id,
    # order_by: [mg.absolute_id, mg.id],
    order_by: [desc: mg.updated_at],
    # where: t.language_id  == ^language_id,
    select: %{localizedName: mg.localizedname, path: mg.path, presenterName: mg.presenter_name, sourceMaterial: mg.source_material, uuid: mg.uuid}
    query
    # |> DB.Query.order_by_last_updated_desc()
    |> Repo.paginate(page: offset, page_size: limit)
  end

  @spec music_by_language(any(), any(), any()) :: nil | Scrivener.Page.t()
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

  def music_media_by_uuid(gid_str, offset \\ 0, limit \\ 0) do
    {:ok, gid_uuid} = Ecto.UUID.dump(gid_str)
    Logger.debug("gid_uuid: #{gid_uuid}")

    query = from m in Music,
    # join: t in MusicTitle,
    # join: c in Chapter,
    join: mm in MediaMusic,

    where: m.uuid == ^gid_uuid,
    # where: t.music_id == m.id,
    # where: t.language_id  == ^language_id,
    # where: c.book_id == g.id,
    # where: c.id == mc.chapter_id,
    # where: mm.language_id == ^language_id,
    where: mm.music_id == m.id,
    order_by: [mm.absolute_id, mm.id],
    # where: t.language_id  == ^language_id,
    select:
    %{localizedName: mm.localizedname,
      path: mm.path,
      presenterName: mm.presenter_name,
      sourceMaterial: mm.source_material,
      uuid: mm.uuid}

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
      client_device ->
        ClientDevice.changeset(%ClientDevice{}, %{
          apns_token: apns_token,
          firebase_token: fcm_token,
          preferred_language: preferred_language,
          user_agent: user_agent,
          user_version: user_version,
          uuid: client_device.uuid
        })
        |> Repo.update()
    end
  end

  def channels_by_org_uuid(orguuid, offset, limit) do
      # python
      # localized_titles = dbsession.query(BookTitle, Book).join(Book).filter(BookTitle.language_id == language_id).order_by(Book.absolute_id.asc()).all()
      {:ok, org_uuid} = Ecto.UUID.dump(orguuid)
      Logger.debug("org_uuid: #{org_uuid}")

      found_org_id = Ecto.Query.from(org in Org,
      where: org.uuid == ^orguuid,
      select: org.id)
      |> Repo.one

      Logger.debug("found_org_id #{inspect %{attributes: found_org_id}}")

      if found_org_id do
        Ecto.Query.from(channel in Channel,
        order_by: channel.ordinal,
        where: channel.org_id  == ^found_org_id,
        select:
        %{basename: channel.basename,
          uuid: channel.uuid,
          ordinal: channel.ordinal,
          basename: channel.basename,
          small_thumbnail_path: channel.small_thumbnail_path,
          med_thumbnail_path: channel.med_thumbnail_path,
          large_thumbnail_path: channel.large_thumbnail_path,
          banner_path: channel.banner_path,
          insertedAt: channel.inserted_at,
          updatedAt: channel.updated_at})
        |> Repo.paginate(page: offset, page_size: limit)
      else
        nil
      end

  end

  def playlists_by_channel_uuid(uuid_str, language_id, offset, limit) do
    {:ok, channel_uuid} = Ecto.UUID.dump(uuid_str)
    Logger.debug("channel_uuid: #{uuid_str}")
    query = from pl in Playlist,

    join: ch in Channel,
    join: pt in PlaylistTitle,

    where: ch.uuid == ^channel_uuid,
    where: ch.id == pl.channel_id,
    where: pl.id == pt.playlist_id,
    where: pt.language_id == ^language_id,

    order_by: [pl.ordinal],

    select:
    %{localizedname: pt.localizedname,
      ordinal: pl.ordinal,
      small_thumbnail_path: pl.small_thumbnail_path,
      med_thumbnail_path: pl.med_thumbnail_path,
      large_thumbnail_path: pl.large_thumbnail_path,
      banner_path: pl.banner_path,
      uuid: pl.uuid,
      inserted_at: pl.inserted_at,
      updated_at: pl.updated_at}
    query
    |> IO.inspect
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def media_items_by_playlist_uuid(playlist_uuid, offset \\ 0, limit \\ 0) do
    {:ok, pid_uuid} = Ecto.UUID.dump(playlist_uuid)
    Logger.debug("pid_uuid: #{pid_uuid}")

    query = from pl in Playlist,
    # join: t in MusicTitle,
    # join: c in Chapter,
    join: mi in MediaItem,

    where: pl.uuid == ^pid_uuid,
    where: mi.playlist_id == pl.id,
    order_by: [mi.track_number, mi.ordinal],
    select:
    %{ordinal: mi.ordinal,
      uuid: mi.uuid,
      track_number: mi.track_number,
      medium: mi.medium,
      localizedname: mi.localizedname,
      path: mi.path,
      content_provider_link: mi.content_provider_link,
      ipfs_link: mi.ipfs_link,
      language_id: mi.language_id,
      presenter_name: mi.presenter_name,
      source_material: mi.source_material,
      playlist_id: mi.playlist_id,
      tags: mi.tags,
      small_thumbnail_path: mi.small_thumbnail_path,
      med_thumbnail_path: mi.med_thumbnail_path,
      large_thumbnail_path: mi.large_thumbnail_path,
      inserted_at: mi.inserted_at,
      updated_at: mi.updated_at}

    query
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def orgs_default_org(offset, limit) do
    # python
    # localized_titles = dbsession.query(BookTitle, Book).join(Book).filter(BookTitle.language_id == language_id).order_by(Book.absolute_id.asc()).all()

  Ecto.Query.from(org in Org,
    where: org.shortname == "faithfulwordapp",
    order_by: org.id,
    select:
    %{basename: org.basename,
      uuid: org.uuid,
      small_thumbnail_path: org.small_thumbnail_path,
      med_thumbnail_path: org.med_thumbnail_path,
      large_thumbnail_path: org.large_thumbnail_path,
      banner_path: org.banner_path,
      insertedAt: org.inserted_at,
      updatedAt: org.updated_at,
      shortname: org.shortname,})
    |> Repo.paginate(page: offset, page_size: limit)
end
end
