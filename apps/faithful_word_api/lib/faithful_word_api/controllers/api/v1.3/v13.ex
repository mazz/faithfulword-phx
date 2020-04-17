defmodule FaithfulWordApi.V13 do
  import Ecto.Query, warn: false
  alias Db.Repo
  alias Ecto.Multi

  alias Db.Schema.{MediaChapter, Chapter, Book}
  alias Db.Schema.{BookTitle, LanguageIdentifier}

  alias Db.Schema.{MediaGospel, Gospel}
  alias Db.Schema.{GospelTitle, LanguageIdentifier}
  alias Db.Schema.{MusicTitle, Music, MediaMusic}
  alias Db.Schema.{Org, Channel, Playlist, PlaylistTitle, MediaItem, PushMessage}
  alias Db.Schema.AppVersion
  alias Db.Schema.ClientDevice

  alias FaithfulWordApi.MediaItemsSearch
  alias FaithfulWord.PushNotifications

  require Ecto.Query
  require Logger
  require DateTime

  def books_by_language(language, offset \\ 0, limit \\ 0) do
    languages =
      Ecto.Query.from(language in LanguageIdentifier,
        select: language.identifier
      )
      |> Repo.all()

    Logger.debug("lang #{inspect(%{attributes: languages})}")

    if !Enum.empty?(languages) do
      # python
      # localized_titles = dbsession.query(BookTitle, Book).join(Book).filter(BookTitle.language_id == language_id).order_by(Book.absolute_id.asc()).all()

      if Enum.find(languages, fn _element -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in Db.Schema.BookTitle,
          join: b in Db.Schema.Book,
          on: title.book_id == b.id,
          where: title.language_id == ^language,
          order_by: b.absolute_id,
          select: %{
            title: b.basename,
            localizedTitle: title.localizedname,
            uuid: b.uuid,
            languageId: title.language_id
          }
        )
        |> Repo.paginate(page: offset, page_size: limit)

        # |> Db.Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect(%{attributes: languages})}")
      nil
    end
  end

  def chapter_media_by_uuid(bid_str, language_id, offset \\ 0, limit \\ 0) do
    {:ok, bid_uuid} = Ecto.UUID.dump(bid_str)
    Logger.debug("bid_uuid: #{bid_uuid}")

    query =
      from(b in Book,
        join: t in BookTitle,
        join: c in Chapter,
        join: mc in MediaChapter,
        where: b.uuid == ^bid_uuid,
        where: t.book_id == b.id,
        where: t.language_id == ^language_id,
        where: c.book_id == b.id,
        where: c.id == mc.chapter_id,
        where: mc.language_id == ^language_id,
        order_by: [mc.absolute_id, mc.id],
        # where: t.language_id  == ^language_id,
        # where: mc.chapter_id == c.id,
        select: %{
          localizedName: mc.localizedname,
          path: mc.path,
          presenterName: mc.presenter_name,
          sourceMaterial: mc.source_material,
          uuid: mc.uuid
        }
      )

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
    languages =
      Ecto.Query.from(language in LanguageIdentifier,
        select: language.identifier
      )
      |> Repo.all()

    Logger.debug("lang #{inspect(%{attributes: languages})}")

    if !Enum.empty?(languages) do
      if Enum.find(languages, fn _element -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in GospelTitle,
          join: g in Gospel,
          on: title.gospel_id == g.id,
          where: title.language_id == ^language,
          order_by: g.absolute_id,
          select: %{
            title: g.basename,
            localizedTitle: title.localizedname,
            uuid: g.uuid,
            languageId: title.language_id
          }
        )
        |> Repo.paginate(page: offset, page_size: limit)

        # |> Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect(%{attributes: languages})}")
      nil
    end
  end

  @spec gospel_media_by_uuid(any(), any(), any()) :: Scrivener.Page.t()
  def gospel_media_by_uuid(gid_str, offset \\ 0, limit \\ 0) do
    {:ok, gid_uuid} = Ecto.UUID.dump(gid_str)
    Logger.debug("gid_str: #{gid_str}")

    query =
      from(g in Gospel,
        join: mg in MediaGospel,
        where: g.uuid == ^gid_uuid,
        where: mg.gospel_id == g.id,
        order_by: [desc: mg.updated_at],
        select: %{
          localizedName: mg.localizedname,
          path: mg.path,
          presenterName: mg.presenter_name,
          sourceMaterial: mg.source_material,
          uuid: mg.uuid
        }
      )

    query
    |> Repo.paginate(page: offset, page_size: limit)
  end

  @spec music_by_language(any(), any(), any()) :: nil | Scrivener.Page.t()
  def music_by_language(language \\ "en", offset \\ 0, limit \\ 0) do
    # Ecto.Query.from(m in Music,
    # order_by: m.absolute_id,
    # select: %{mid: m.uuid, title: m.title})
    # |> Repo.paginate(page: offset, page_size: limit)

    languages =
      Ecto.Query.from(language in LanguageIdentifier,
        select: language.identifier
      )
      |> Repo.all()

    Logger.debug("lang #{inspect(%{attributes: languages})}")

    if !Enum.empty?(languages) do
      if Enum.find(languages, fn _element -> String.starts_with?(language, languages) end) do
        Ecto.Query.from(title in MusicTitle,
          join: m in Music,
          on: title.music_id == m.id,
          where: title.language_id == ^language,
          order_by: m.absolute_id,
          select: %{
            title: m.basename,
            localizedTitle: title.localizedname,
            uuid: m.uuid,
            languageId: title.language_id
          }
        )
        |> Repo.paginate(page: offset, page_size: limit)

        # |> Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect(%{attributes: languages})}")
      nil
    end
  end

  def music_media_by_uuid(gid_str, offset \\ 0, limit \\ 0) do
    {:ok, gid_uuid} = Ecto.UUID.dump(gid_str)
    Logger.debug("gid_str: #{gid_str}")

    query =
      from(m in Music,
        join: mm in MediaMusic,
        where: m.uuid == ^gid_uuid,
        where: mm.music_id == m.id,
        order_by: [mm.absolute_id, mm.id],
        select: %{
          localizedName: mm.localizedname,
          path: mm.path,
          presenterName: mm.presenter_name,
          sourceMaterial: mm.source_material,
          uuid: mm.uuid
        }
      )

    query
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def language_identifiers(offset \\ 0, limit \\ 0) do
    Ecto.Query.from(lid in LanguageIdentifier,
      order_by: lid.identifier,
      select: %{
        identifier: lid.identifier,
        source_material: lid.source_material,
        supported: lid.supported,
        uuid: lid.uuid
      }
    )
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def app_versions(offset \\ 0, limit \\ 0) do
    Ecto.Query.from(av in AppVersion,
      order_by: av.id,
      select: %{
        version_number: av.version_number,
        ios_supported: av.ios_supported,
        android_supported: av.android_supported,
        web_supported: av.web_supported,
        uuid: av.uuid
      }
    )
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def add_or_update_push_message(
        title,
        message,
        thumbnail_path,
        org_id,
        message_uuid \\ nil
      ) do
    {:ok, messageuuid} =
      if message_uuid do
        Ecto.UUID.dump(message_uuid)
      else
        Ecto.UUID.dump("00000000-0000-0000-0000-000000000000")
      end

    case Repo.get_by(PushMessage, uuid: messageuuid) do
      nil ->
        changeset =
          PushMessage.changeset(%PushMessage{}, %{
            title: title,
            message: message,
            thumbnail_path: thumbnail_path,
            org_id: org_id,
            uuid: Ecto.UUID.generate()
          })

        Multi.new()
        |> Multi.insert(:push_message, changeset)
        |> Repo.transaction()
        |> case do
          {:ok, %{push_message: push_message}} ->
            {:ok, push_message}

          {:error, _, error, _} ->
            {:error, error}
        end

      push_message ->
        changeset =
          PushMessage.changeset(%PushMessage{id: push_message.id}, %{
            message: message,
            title: title,
            updated_at: DateTime.utc_now(),
            thumbnail_path: thumbnail_path,
            org_id: org_id,
            uuid: push_message.uuid,
            sent: push_message.sent
          })

        Multi.new()
        |> Multi.update(:push_message, changeset)
        |> Repo.transaction()
        |> case do
          {:ok, %{push_message: push_message}} ->
            {:ok, push_message}

          {:error, _, error, _} ->
            {:error, error}
        end
    end
  end

  def send_push_message(message_uuid, media_item_uuid) when is_nil(media_item_uuid) do
    {:ok, messageuuid} = Ecto.UUID.dump(message_uuid)

    case Repo.get_by(PushMessage, uuid: messageuuid) do
      nil ->
        {:error, :not_found}

      push_message ->
        PushNotifications.send_pushmessage_now(push_message)

        changeset =
          PushMessage.changeset(%PushMessage{id: push_message.id}, %{
            message: push_message.message,
            title: push_message.title,
            thumbnail_path: push_message.thumbnail_path,
            updated_at: DateTime.utc_now(),
            org_id: push_message.org_id,
            uuid: push_message.uuid,
            sent: true
          })

        Multi.new()
        |> Multi.update(:push_message, changeset)
        |> Repo.transaction()
        |> case do
          {:ok, %{push_message: push_message}} ->
            {:ok, push_message}

          {:error, _, error, _} ->
            {:error, error}
        end
    end
  end

  def send_push_message(message_uuid, media_item_uuid) do
    {:ok, messageuuid} = Ecto.UUID.dump(message_uuid)

    case Repo.get_by(PushMessage, uuid: messageuuid) do
      nil ->
        {:error, :not_found}

      push_message ->
        PushNotifications.send_pushmessage_now(push_message, media_item_uuid)

        changeset =
          PushMessage.changeset(%PushMessage{id: push_message.id}, %{
            message: push_message.message,
            title: push_message.title,
            thumbnail_path: push_message.thumbnail_path,
            updated_at: DateTime.utc_now(),
            org_id: push_message.org_id,
            uuid: push_message.uuid,
            sent: true
          })

        Multi.new()
        |> Multi.update(:push_message, changeset)
        |> Repo.transaction()
        |> case do
          {:ok, %{push_message: push_message}} ->
            {:ok, push_message}

          {:error, _, error, _} ->
            {:error, error}
        end
    end
  end

  def add_or_update_media_item(
        ordinal,
        localizedname,
        media_category,
        medium,
        path,
        language_id,
        playlist_id,
        org_id,
        # optional >>>
        track_number,
        tags,
        small_thumbnail_path,
        med_thumbnail_path,
        large_thumbnail_path,
        content_provider_link,
        ipfs_link,
        presenter_name,
        presented_at,
        source_material,
        duration,
        media_item_uuid \\ nil
      ) do
    {:ok, media_itemuuid} =
      if media_item_uuid do
        Ecto.UUID.dump(media_item_uuid)
      else
        Ecto.UUID.dump("00000000-0000-0000-0000-000000000000")
      end

    # check if we already have the media_item
    # if media_item is not present, ADD
    # if media_item is present in db, UPDATE

    case Repo.get_by(MediaItem, uuid: media_itemuuid) do
      # add media_item
      nil ->
        changeset =
          MediaItem.changeset(%MediaItem{tags: tags}, %{
            ordinal: ordinal,
            localizedname: localizedname,
            media_category: media_category,
            medium: medium,
            path: path,
            language_id: language_id,
            playlist_id: playlist_id,
            org_id: org_id,
            track_number: track_number,
            tags: tags,
            small_thumbnail_path: small_thumbnail_path,
            med_thumbnail_path: med_thumbnail_path,
            large_thumbnail_path: large_thumbnail_path,
            content_provider_link: content_provider_link,
            ipfs_link: ipfs_link,
            presenter_name: presenter_name,
            presented_at: presented_at,
            source_material: source_material,
            duration: duration,
            uuid: Ecto.UUID.generate()
          })

        Logger.debug("media_item changeset #{inspect(%{attributes: changeset})}")

        Multi.new()
        |> Multi.insert(:item_without_hash_id, changeset)
        |> Multi.run(:media_item, fn _repo, %{item_without_hash_id: media_item} ->
          Logger.debug("media_item insert #{inspect(%{attributes: media_item})}")

          media_item
          |> MediaItem.changeset_generate_hash_id()
          |> Repo.update()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{media_item: media_item}} ->
            {:ok, media_item}

          {:error, _, error, _} ->
            {:error, error}
        end

      media_item ->
        changeset =
          MediaItem.changeset(%MediaItem{id: media_item.id}, %{
            ordinal: ordinal,
            localizedname: localizedname,
            media_category: media_category,
            medium: medium,
            path: path,
            language_id: language_id,
            playlist_id: playlist_id,
            org_id: org_id,
            track_number: track_number,
            tags: tags,
            small_thumbnail_path: small_thumbnail_path,
            med_thumbnail_path: med_thumbnail_path,
            large_thumbnail_path: large_thumbnail_path,
            content_provider_link: content_provider_link,
            ipfs_link: ipfs_link,
            presenter_name: presenter_name,
            presented_at: presented_at,
            source_material: source_material,
            duration: duration,
            uuid: media_item.uuid,
            updated_at: DateTime.utc_now()
          })

        Multi.new()
        |> Multi.update(:media_item, changeset)
        |> Repo.transaction()
        |> case do
          {:ok, %{media_item: media_item}} ->
            {:ok, media_item}

          {:error, _, error, _} ->
            {:error, error}
        end
    end
  end

  def delete_media_item(media_item_uuid) do
    {:ok, media_itemuuid} =
      if media_item_uuid do
        Ecto.UUID.dump(media_item_uuid)
      else
        Ecto.UUID.dump("00000000-0000-0000-0000-000000000000")
      end

    case Repo.get_by(MediaItem, uuid: media_itemuuid) do
      # no media_item title by that uuid
      nil ->
        {:error, :not_found}

        media_item ->
        Repo.delete!(media_item)

        {:ok, media_item}
    end
  end

  def delete_playlist_title(playlist_title_uuid) do
    {:ok, playlisttitleuuid} =
      if playlist_title_uuid do
        Ecto.UUID.dump(playlist_title_uuid)
      else
        Ecto.UUID.dump("00000000-0000-0000-0000-000000000000")
      end

    case Repo.get_by(PlaylistTitle, uuid: playlisttitleuuid) do
      # no playlist title by that uuid
      nil ->
        {:error, :not_found}

      playlist_title ->
        Repo.delete!(playlist_title)

        {:ok, playlist_title}
    end
  end

  def add_or_update_playlist(
        ordinal,
        basename,
        small_thumbnail_path,
        med_thumbnail_path,
        large_thumbnail_path,
        banner_path,
        media_category,
        localized_titles,
        channel_id,
        playlist_uuid \\ nil
      ) do
    {:ok, playlistuuid} =
      if playlist_uuid do
        Ecto.UUID.dump(playlist_uuid)
      else
        Ecto.UUID.dump("00000000-0000-0000-0000-000000000000")
      end

    # check if we already have the playlist
    # if playlist is not present, ADD
    # if playlist is present in db, UPDATE

    case Repo.get_by(Playlist, uuid: playlistuuid) do
      # add playlist
      nil ->
        changeset =
          Playlist.changeset(
            %Playlist{
              basename: basename,
              small_thumbnail_path: small_thumbnail_path,
              med_thumbnail_path: med_thumbnail_path,
              large_thumbnail_path: large_thumbnail_path,
              banner_path: banner_path
            },
            %{
              ordinal: ordinal,
              basename: basename,
              small_thumbnail_path: small_thumbnail_path,
              med_thumbnail_path: med_thumbnail_path,
              large_thumbnail_path: large_thumbnail_path,
              banner_path: banner_path,
              media_category: media_category,
              channel_id: channel_id,
              uuid: Ecto.UUID.generate()
            }
          )

        Multi.new()
        |> Multi.insert(:item_without_hash_id, changeset)
        |> Multi.run(:playlist, fn _repo, %{item_without_hash_id: playlist} ->
          playlist
          |> Playlist.changeset_generate_hash_id()
          |> Repo.update()
        end)
        # iterate over the localized_titles and add to db
        # pass in playlist that was just inserted
        |> Multi.run(:add_localized_titles, fn _repo, %{playlist: playlist} ->
          maps =
            for title <- localized_titles,
                _ = Logger.debug("title #{inspect(%{attributes: title})}"),
                {k, v} <- title do
              IO.puts("#{k} --> #{v}")

              Repo.insert(%PlaylistTitle{
                language_id: k,
                localizedname: v,
                uuid: Ecto.UUID.generate(),
                playlist_id: playlist.id
              })
            end

          Logger.debug("maps #{inspect(%{attributes: maps})}")
          {:ok, maps}
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{playlist: playlist}} ->
            {:ok, playlist}

          {:error, _, error, _} ->
            {:error, error}
        end

      # update playlist
      playlist ->
        # changeset = User.changeset(user, params)

        changeset =
          Playlist.changeset(
            %Playlist{
              id: playlist.id
            },
            %{
              uuid: playlist.uuid,
              ordinal: ordinal,
              basename: basename,
              small_thumbnail_path: small_thumbnail_path,
              med_thumbnail_path: med_thumbnail_path,
              large_thumbnail_path: large_thumbnail_path,
              banner_path: banner_path,
              media_category: media_category,
              channel_id: channel_id,
              updated_at: DateTime.utc_now()
            }
          )

        Multi.new()
        |> Multi.update(:playlist, changeset)

        # iterate over the localized_titles and add/update to db
        # pass in playlist that was just added/updated
        |> Multi.run(:add_localized_titles, fn _repo, %{playlist: playlist} ->
          maps =
            for title <- localized_titles,
                _ = Logger.debug("title #{inspect(%{attributes: title})}"),
                {k, v} <- title do
              IO.puts("#{k} --> #{v}")

              # check if playlist title is already in db
              title_query =
                from(title in PlaylistTitle,
                  where: title.language_id == ^k and title.playlist_id == ^playlist.id
                )

              one_title = Repo.one(title_query)

              case one_title do
                # playlist title is not in db, so add it
                nil ->
                  IO.inspect(one_title)

                  Repo.insert(%PlaylistTitle{
                    language_id: k,
                    localizedname: v,
                    uuid: Ecto.UUID.generate(),
                    playlist_id: playlist.id
                  })

                title ->
                  # playlist title IS in db, so update it
                  IO.inspect(title)

                  PlaylistTitle.changeset(
                    %PlaylistTitle{
                      id: title.id
                    },
                    %{
                      uuid: title.uuid,
                      language_id: k,
                      localizedname: v,
                      playlist_id: playlist.id,
                      updated_at: DateTime.utc_now()
                    }
                  )
                  |> Repo.update()
              end
            end

          Logger.debug("maps #{inspect(%{attributes: maps})}")
          {:ok, maps}
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{playlist: playlist}} ->
            {:ok, playlist}

          {:error, _, error, _} ->
            {:error, error}
        end
    end
  end

  def delete_playlist(playlist_uuid) do
    {:ok, playlistuuid} =
      if playlist_uuid do
        Ecto.UUID.dump(playlist_uuid)
      else
        Ecto.UUID.dump("00000000-0000-0000-0000-000000000000")
      end

    case Repo.get_by(Playlist, uuid: playlistuuid) do
      # no playlist title by that uuid
      nil ->
        {:error, :not_found}

      playlist ->
        Repo.delete!(playlist)

        {:ok, playlist}
    end
  end

  def add_or_update_channel(
        ordinal,
        basename,
        small_thumbnail_path,
        med_thumbnail_path,
        large_thumbnail_path,
        banner_path,
        org_id,
        channel_uuid \\ nil
      ) do
    {:ok, channeluuid} =
      if channel_uuid do
        Ecto.UUID.dump(channel_uuid)
      else
        Ecto.UUID.dump("00000000-0000-0000-0000-000000000000")
      end

    case Repo.get_by(Channel, uuid: channeluuid) do
      nil ->
        changeset =
          Channel.changeset(
            %Channel{
              ordinal: ordinal,
              basename: basename,
              small_thumbnail_path: small_thumbnail_path,
              med_thumbnail_path: med_thumbnail_path,
              large_thumbnail_path: large_thumbnail_path,
              banner_path: banner_path
            },
            %{
              ordinal: ordinal,
              basename: basename,
              small_thumbnail_path: small_thumbnail_path,
              med_thumbnail_path: med_thumbnail_path,
              large_thumbnail_path: large_thumbnail_path,
              banner_path: banner_path,
              org_id: org_id,
              uuid: Ecto.UUID.generate()
            }
          )

        Multi.new()
        |> Multi.insert(:item_without_hash_id, changeset)
        |> Multi.run(:channel, fn _repo, %{item_without_hash_id: channel} ->
          channel
          |> Channel.changeset_generate_hash_id()
          |> Repo.update()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{channel: channel}} ->
            {:ok, channel}

          {:error, _, error, _} ->
            {:error, error}

            # {:reply, {:error, ChangesetView.render("error.json", %{changeset: changeset})}, socket}
            # {:reply, {:error, "Unknown error", socket}}
        end

      channel ->
        changeset =
          Channel.changeset(
            %Channel{
              id: channel.id
            },
            %{
              ordinal: ordinal,
              basename: basename,
              org_id: org_id,
              uuid: channel.uuid,
              small_thumbnail_path: small_thumbnail_path,
              med_thumbnail_path: med_thumbnail_path,
              large_thumbnail_path: large_thumbnail_path,
              banner_path: banner_path,
              updated_at: DateTime.utc_now()
            }
          )

        Multi.new()
        |> Multi.update(:channel, changeset)
        |> Repo.transaction()
        |> case do
          {:ok, %{channel: channel}} ->
            {:ok, channel}

          {:error, _, error, _} ->
            {:error, error}
        end
    end
  end

  def delete_channel(channel_uuid) do
    {:ok, channeluuid} =
      if channel_uuid do
        Ecto.UUID.dump(channel_uuid)
      else
        Ecto.UUID.dump("00000000-0000-0000-0000-000000000000")
      end

    case Repo.get_by(Channel, uuid: channeluuid) do
      # no channel title by that uuid
      nil ->
        {:error, :not_found}

        channel ->
        Repo.delete!(channel)

        {:ok, channel}
    end
  end

  def add_client_device(fcm_token, apns_token, preferred_language, user_agent, user_version, org_id) do
    case Repo.get_by(ClientDevice, firebase_token: fcm_token) do
      nil ->
        ClientDevice.changeset(%ClientDevice{}, %{
          apns_token: apns_token,
          firebase_token: fcm_token,
          preferred_language: preferred_language,
          user_agent: user_agent,
          user_version: user_version,
          org_id: org_id,
          uuid: Ecto.UUID.generate()
        })
        |> Repo.insert()

      client_device ->
        ClientDevice.changeset(%ClientDevice{id: client_device.id}, %{
          apns_token: apns_token,
          firebase_token: fcm_token,
          preferred_language: preferred_language,
          user_agent: user_agent,
          user_version: user_version,
          org_id: org_id,
          uuid: client_device.uuid
        })
        |> Repo.update()
    end
  end

  def channels_by_org_uuid(orguuid, offset, limit, updated_after) do
    # python
    # localized_titles = dbsession.query(BookTitle, Book).join(Book).filter(BookTitle.language_id == language_id).order_by(Book.absolute_id.asc()).all()
    {:ok, org_uuid} = Ecto.UUID.dump(orguuid)
    Logger.debug("channel_uuid: #{updated_after}")

    conditions = true

    conditions =
      if updated_after != nil do
        updated_after_int = String.to_integer(updated_after)

        if updated_after_int do
          {:ok, datetime} = DateTime.from_unix(updated_after_int, :second)
          naive = DateTime.to_naive(datetime)
          dynamic([chn], chn.updated_at >= ^naive and ^conditions)
        else
          conditions
        end
      else
        true
      end

    query =
      from(channel in Channel,
        join: org in Org,
        where: org.uuid == ^org_uuid,
        where: org.id == channel.org_id,
        where: ^conditions,
        order_by: channel.ordinal,
        select: %{
          basename: channel.basename,
          uuid: channel.uuid,
          org_uuid: org.uuid,
          ordinal: channel.ordinal,
          basename: channel.basename,
          channel_id: channel.id,
          small_thumbnail_path: channel.small_thumbnail_path,
          med_thumbnail_path: channel.med_thumbnail_path,
          large_thumbnail_path: channel.large_thumbnail_path,
          banner_path: channel.banner_path,
          inserted_at: channel.inserted_at,
          updated_at: channel.updated_at,
          hash_id: channel.hash_id
        }
      )

    query
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def playlist_details_by_uuid(uuid_str, offset, limit, updated_after) do
    {:ok, playlist_uuid} = Ecto.UUID.dump(uuid_str)
    Logger.debug("playlist_uuid: #{uuid_str}")
    Logger.debug("channel_uuid: #{updated_after}")

    conditions = true

    conditions =
      if updated_after != nil do
        updated_after_int = String.to_integer(updated_after)

        if updated_after_int do
          {:ok, datetime} = DateTime.from_unix(updated_after_int, :second)
          naive = DateTime.to_naive(datetime)
          dynamic([det], det.updated_at >= ^naive and ^conditions)
        else
          conditions
        end
      else
        true
      end

    Ecto.Query.from(pl in Playlist,
      where: pl.uuid == ^playlist_uuid,
      where: ^conditions,
      preload: [:playlist_titles],
      select: %{
        playlist: pl
      }
    )
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def playlists_by_channel_uuid(uuid_str, language_id, offset, limit, updated_after) do
    {:ok, channel_uuid} = Ecto.UUID.dump(uuid_str)
    Logger.debug("channel_uuid: #{uuid_str}")
    Logger.debug("channel_uuid: #{updated_after}")

    conditions = true

    conditions =
      if updated_after != nil do
        updated_after_int = String.to_integer(updated_after)

        if updated_after_int do
          {:ok, datetime} = DateTime.from_unix(updated_after_int, :second)
          naive = DateTime.to_naive(datetime)
          dynamic([playlists], playlists.updated_at >= ^naive and ^conditions)
        else
          conditions
        end
      else
        true
      end

    query =
      from(pl in Playlist,
        join: ch in Channel,
        join: pt in PlaylistTitle,
        where: ch.uuid == ^channel_uuid,
        where: ch.id == pl.channel_id,
        where: pl.id == pt.playlist_id,
        where: pt.language_id == ^language_id,
        where: ^conditions,
        order_by: [pl.ordinal],
        select: %{
          basename: pl.basename,
          localizedname: pt.localizedname,
          language_id: pt.language_id,
          ordinal: pl.ordinal,
          small_thumbnail_path: pl.small_thumbnail_path,
          med_thumbnail_path: pl.med_thumbnail_path,
          large_thumbnail_path: pl.large_thumbnail_path,
          banner_path: pl.banner_path,
          media_category: pl.media_category,
          uuid: pl.uuid,
          channel_uuid: ch.uuid,
          channel_id: ch.id,
          inserted_at: pl.inserted_at,
          updated_at: pl.updated_at,
          hash_id: pl.hash_id
        }
      )

    query
    |> IO.inspect()
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def media_items_by_playlist_uuid(
        playlist_uuid,
        language_id,
        offset \\ 0,
        limit \\ 0,
        updated_after
      ) do
    {:ok, pid_uuid} = Ecto.UUID.dump(playlist_uuid)
    Logger.debug("pid_uuid: #{pid_uuid}")
    Logger.debug("updated_after: #{updated_after}")

    category_and_multilanguage =
      Ecto.Query.from(playlist in Playlist,
        where: playlist.uuid == ^playlist_uuid,
        select: %{media_category: playlist.media_category, multilanguage: playlist.multilanguage}
      )
      |> Repo.one()
      |> IO.inspect()

    special_categories = [:livestream, :motivation, :movie, :podcast, :testimony, :preaching]

    {direction, sorting} =
      if category_and_multilanguage.media_category in special_categories do
        # do not use presented_at because many presented_at dates are identical
        {:desc, :inserted_at}
      else
        {:asc, :ordinal}
      end

    Logger.info("direction: #{direction} sorting: #{sorting}")

    conditions = true

    conditions =
      if !category_and_multilanguage.multilanguage do
        dynamic([pl, mi], mi.language_id == ^language_id and ^conditions)
        # dynamic([mi], mi.language_id == ^language_id and ^conditions)
      else
        conditions
      end

    conditions =
      if updated_after != nil do
        updated_after_int = String.to_integer(updated_after)

        if updated_after_int do
          {:ok, datetime} = DateTime.from_unix(updated_after_int, :second)
          naive = DateTime.to_naive(datetime)
          dynamic([orgs], orgs.updated_at >= ^naive and ^conditions)
        else
          conditions
        end
      else
        true
      end

    query =
      from(pl in Playlist,
        join: mi in MediaItem,
        where: pl.uuid == ^pid_uuid,
        where: mi.playlist_id == pl.id,
        where: ^conditions,
        where: mi.language_id == ^language_id,
        order_by: [{^direction, field(mi, ^sorting)}],
        select: %{
          ordinal: mi.ordinal,
          uuid: mi.uuid,
          track_number: mi.track_number,
          medium: mi.medium,
          localizedname: mi.localizedname,
          multilanguage: pl.multilanguage,
          path: mi.path,
          content_provider_link: mi.content_provider_link,
          ipfs_link: mi.ipfs_link,
          language_id: mi.language_id,
          presenter_name: mi.presenter_name,
          source_material: mi.source_material,
          playlist_uuid: pl.uuid,
          tags: mi.tags,
          small_thumbnail_path: mi.small_thumbnail_path,
          med_thumbnail_path: mi.med_thumbnail_path,
          large_thumbnail_path: mi.large_thumbnail_path,
          inserted_at: mi.inserted_at,
          updated_at: mi.updated_at,
          media_category: mi.media_category,
          presented_at: mi.presented_at,
          published_at: mi.published_at,
          hash_id: mi.hash_id,
          duration: mi.duration
        }
      )

    query
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def media_item_by_hash_id(hash_id) do
    Logger.debug("hash_id: #{hash_id}")

    query =
      from(mi in MediaItem,
        join: pl in Playlist,
        where: mi.hash_id == ^hash_id,
        where: mi.playlist_id == pl.id,
        select: %{
          ordinal: mi.ordinal,
          uuid: mi.uuid,
          track_number: mi.track_number,
          medium: mi.medium,
          localizedname: mi.localizedname,
          multilanguage: pl.multilanguage,
          path: mi.path,
          content_provider_link: mi.content_provider_link,
          ipfs_link: mi.ipfs_link,
          language_id: mi.language_id,
          presenter_name: mi.presenter_name,
          source_material: mi.source_material,
          tags: mi.tags,
          small_thumbnail_path: mi.small_thumbnail_path,
          med_thumbnail_path: mi.med_thumbnail_path,
          large_thumbnail_path: mi.large_thumbnail_path,
          inserted_at: mi.inserted_at,
          updated_at: mi.updated_at,
          media_category: mi.media_category,
          presented_at: mi.presented_at,
          published_at: mi.published_at,
          hash_id: mi.hash_id,
          playlist_uuid: pl.uuid,
          duration: mi.duration
        }
      )


    case Repo.one(query) do
      nil ->
        {:error, nil}
      media_item ->
        {:ok, media_item}
    end
  end

  def media_item_by_uuid(uuid_str) do
    {:ok, media_item_uuid} = Ecto.UUID.dump(uuid_str)
    Logger.debug("media_item_uuid: #{uuid_str}")

    query =
      from(mi in MediaItem,
        join: pl in Playlist,
        where: mi.uuid == ^media_item_uuid,
        where: mi.playlist_id == pl.id,
        select: %{
          ordinal: mi.ordinal,
          uuid: mi.uuid,
          track_number: mi.track_number,
          medium: mi.medium,
          localizedname: mi.localizedname,
          multilanguage: pl.multilanguage,
          path: mi.path,
          content_provider_link: mi.content_provider_link,
          ipfs_link: mi.ipfs_link,
          language_id: mi.language_id,
          presenter_name: mi.presenter_name,
          source_material: mi.source_material,
          tags: mi.tags,
          small_thumbnail_path: mi.small_thumbnail_path,
          med_thumbnail_path: mi.med_thumbnail_path,
          large_thumbnail_path: mi.large_thumbnail_path,
          inserted_at: mi.inserted_at,
          updated_at: mi.updated_at,
          media_category: mi.media_category,
          presented_at: mi.presented_at,
          published_at: mi.published_at,
          hash_id: mi.hash_id,
          playlist_uuid: pl.uuid,
          # playlist_id: pl.id,
          duration: mi.duration
        }
      )

      case Repo.one(query) do
        nil ->
          {:error, nil}
        media_item ->
          {:ok, media_item}
      end
  end

  def orgs_default_org(offset \\ 0, limit \\ 0, updated_after) do
    # python
    # localized_titles = dbsession.query(BookTitle, Book).join(Book).filter(BookTitle.language_id == language_id).order_by(Book.absolute_id.asc()).all()

    Logger.debug("updated_after: #{updated_after}")

    conditions = true

    conditions =
      if updated_after != nil do
        updated_after_int = String.to_integer(updated_after)

        if updated_after_int do
          {:ok, datetime} = DateTime.from_unix(updated_after_int, :second)
          naive = DateTime.to_naive(datetime)
          dynamic([orgs], orgs.updated_at >= ^naive and ^conditions)
        else
          conditions
        end
      else
        true
      end

    Ecto.Query.from(org in Org,
      where: org.shortname == "faithfulwordapp",
      where: ^conditions,
      preload: [:channels],
      order_by: org.id,
      select: %{
        org: org
      }
    )
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def add_or_update_org(
    basename,
    shortname,
    small_thumbnail_path,
    med_thumbnail_path,
    large_thumbnail_path,
    banner_path,
    org_uuid
  ) do
    {:ok, orguuid} =
      if org_uuid do
        Ecto.UUID.dump(org_uuid)
      else
        Ecto.UUID.dump("00000000-0000-0000-0000-000000000000")
      end

    case Repo.get_by(Org, uuid: orguuid) do
      nil ->
        Logger.debug("new org changeset")
        changeset =
          Org.changeset(
            %Org{
              basename: basename,
              shortname: shortname,
              small_thumbnail_path: small_thumbnail_path,
              med_thumbnail_path: med_thumbnail_path,
              large_thumbnail_path: large_thumbnail_path,
              banner_path: banner_path
            },
            %{
              basename: basename,
              shortname: shortname,
              small_thumbnail_path: small_thumbnail_path,
              med_thumbnail_path: med_thumbnail_path,
              large_thumbnail_path: large_thumbnail_path,
              banner_path: banner_path,
              uuid: Ecto.UUID.generate()
            }
          )
        Logger.debug("new changeset")
        IO.inspect(changeset)

        Multi.new()
        |> Multi.insert(:item_without_hash_id, changeset)
        |> Multi.run(:org, fn _repo, %{item_without_hash_id: org} ->
          org
          |> Org.changeset_generate_hash_id()
          |> Repo.update()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{org: org}} ->
            Logger.debug("about to return new org")
            IO.inspect(org)
            {:ok, org}

          {:error, _, error, _} ->
            Logger.debug("about to return new error")
            IO.inspect(error)
            {:error, error}
        end

        org ->
          Logger.debug("found org")
          IO.inspect(org)
        changeset =
          Org.changeset(
            %Org{
              id: org.id
            },
            %{
              basename: basename,
              shortname: shortname,
              uuid: org.uuid,
              small_thumbnail_path: small_thumbnail_path,
              med_thumbnail_path: med_thumbnail_path,
              large_thumbnail_path: large_thumbnail_path,
              banner_path: banner_path,
              hash_id: org.hash_id,
              updated_at: DateTime.utc_now()
            }
          )
        Logger.debug("changeset")
        IO.inspect(changeset)

        Multi.new()
        |> Multi.update(:org, changeset)
        |> Repo.transaction()
        |> case do
          {:ok, %{org: org}} ->
            {:ok, org}

          {:error, _, error, _} ->
            {:error, error}
        end
    end
  end

  def delete_org(org_uuid) do
    {:ok, orguuid} =
      if org_uuid do
        Ecto.UUID.dump(org_uuid)
      else
        Ecto.UUID.dump("00000000-0000-0000-0000-000000000000")
      end

    case Repo.get_by(Org, uuid: orguuid) do
      # no org title by that uuid
      nil ->
        {:error, :not_found}

      org ->
        Repo.delete!(org)

        {:ok, org}
    end
  end

  def search(
        query_string,
        offset \\ 0,
        limit \\ 0,
        media_category,
        playlist_uuid,
        channel_uuid,
        published_after,
        updated_after,
        presented_after
      ) do
    conditions = true

    conditions =
      if media_category do
        dynamic([mi], mi.media_category == ^media_category and ^conditions)
      else
        conditions
      end

    # jan 2019: 1546527751
    # jan 2020: 1578063751
    # apr 29 2019: 1556550151
    # April 26, 2013 3:02:31 PM: 1366988551
    # May 3, 2017 11:16:55 PM: 1493853415
    # May 3, 2018 11:16:55 PM: 1525389415
    # preaching channel uuid f467f75c-937a-46a3-a21f-880bb9777408
    # music channel uuid 52f758d2-ce64-4ffd-8d3c-77f598003ee1
    conditions =
      if published_after do
        {:ok, datetime} = DateTime.from_unix(published_after, :second)
        naive = DateTime.to_naive(datetime)
        dynamic([mi], mi.published_at >= ^naive and ^conditions)
      else
        conditions
      end

    conditions =
      if updated_after do
        {:ok, datetime} = DateTime.from_unix(updated_after, :second)
        naive = DateTime.to_naive(datetime)
        dynamic([mi], mi.updated_at >= ^naive and ^conditions)
      else
        conditions
      end

    conditions =
      if presented_after do
        {:ok, datetime} = DateTime.from_unix(presented_after, :second)
        naive = DateTime.to_naive(datetime)
        dynamic([mi], mi.presented_at >= ^naive and ^conditions)
      else
        conditions
      end

    Logger.info("channel_uuid: #{channel_uuid}")
    Logger.info("playlist_uuid: #{playlist_uuid}")

    query =
      if playlist_uuid do
        search_by_playlist_query(playlist_uuid, conditions)
      else
        search_by_channel_query(channel_uuid, conditions)
      end

    MediaItemsSearch.run(query, query_string)
    |> Repo.paginate(page: offset, page_size: limit)
  end

  def search_by_playlist_query(nil, conditions) do
    Ecto.Query.from(mi in MediaItem, where: ^conditions)
  end

  def search_by_playlist_query(playlist_uuid, conditions) do
    # """
    #   -- all the mediaitems in a playlist
    #   select *
    #   from mediaitems
    #   inner join playlists on mediaitems.playlist_id = playlists.id
    #   where playlists.id = 118
    # """

    from(mi in MediaItem,
      join: pl in Playlist,
      where: mi.playlist_id == pl.id,
      where: pl.uuid == ^playlist_uuid,
      where: ^conditions
    )
  end

  def search_by_channel_query(nil, conditions) do
    Ecto.Query.from(mi in MediaItem, where: ^conditions)
  end

  def search_by_channel_query(channel_uuid, conditions) do
    # """
    #   -- all the mediaitems in a channel
    #   select *
    #   from mediaitems
    #   inner join playlists on mediaitems.playlist_id = playlists.id
    #   inner join channels on playlists.channel_id = channels.id
    #   where channels.id = 2
    # """
    Logger.info("channel_uuid: #{channel_uuid}")

    from(mi in MediaItem,
      join: pl in Playlist,
      join: ch in Channel,
      where: mi.playlist_id == pl.id,
      where: pl.channel_id == ch.id,
      where: ch.uuid == ^channel_uuid,
      where: ^conditions
    )
  end
end
