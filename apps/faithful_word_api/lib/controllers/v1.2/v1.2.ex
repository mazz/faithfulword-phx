defmodule FaithfulWordApi.V12 do

  import Ecto.Query, warn: false
  alias DB.Repo

  alias DB.Schema.{MediaChapter, Chapter, Book}
  alias DB.Schema.{BookTitle, LanguageIdentifier}

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
        Ecto.Query.from(title in BookTitle,
          join: b in Book,
          on: title.book_id == b.id,
          where: title.language_id  == ^language,
          order_by: b.absolute_id,
          select: %{title: b.basename, localizedTitle: title.localizedname, uuid: b.uuid, languageId: title.language_id})
          |> Repo.all
      else
        nil
      end
    else
      Logger.debug("lang empty #{inspect %{attributes: languages}}")
      nil
    end
  end

  """
  mediachapter = dbsession.query(MediaChapter).join(Chapter).join(Book).filter(Book.uuid == book_uuid.hex).filter(MediaChapter.language_id == language_id).order_by(MediaChapter.absolute_id.asc(), MediaChapter.id.asc()).all()
  media_chapter_list = []

  ''' iterate over the mediachapter tuples and
      extract the localizedName and path to the
      audio file '''

  for idx, row in enumerate(mediachapter):
      media_chapter_dict = {}
      # LOG.info('row: {}'.format(repr(row)))
      media_chapter_dict['localizedName'] = row.localizedname
      media_chapter_dict['path'] = row.path
      media_chapter_dict['presenterName'] = row.presenter_name
      media_chapter_dict['sourceMaterial'] = row.source_material
      media_chapter_dict['uuid'] = str(row.uuid)
      media_chapter_list.append(media_chapter_dict)

  response_dict = dict(status='success', result = media_chapter_list, version = '{}'.format(str(api_version)))
  return response_dict
  """

  def chapter_media_by_bid(bid_str, language_id) do
    {:ok, bid_uuid} = Ecto.UUID.dump(bid_str)
    Logger.debug("bid_uuid: #{bid_uuid}")
    query = from b in Book,
    join: t in BookTitle,
    join: c in Chapter,
    join: mc in MediaChapter,
    # on: b.uuid == ^bid_uuid,
    # on: t.book_id == b.id,
    # on: t.language_id  == ^language_id,
    # on: mc.chapter_id == c.id,

    # on: c.book_id == b.id,
    # on: c.uuid
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

    Logger.debug("Repo.all(query):")
    IO.inspect(Repo.all(query))

      # from(
      #   b in Book,
      #   where: b.uuid == ^bid_uuid,
      #   select: %{b.basename}
        # mc in MediaChapter,
        # join: c in Chapter,
        # join: b in Book,
        # where: mc.language_id == ^language_id,
        # order_by: mc.absolute_id,
        # select: %{localizedName: mc.localizedname, path: mc.path, presenterName: mc.presenter_name, sourceMaterial: mc.source_material, uuid: mc.uuid}
      # )
      Repo.all(query)
  end
end


  # def videos_speakers(videos_ids) do
  #   query =
  #     from(
  #       s in Speaker,
  #       join: vs in VideoSpeaker,
  #       on: vs.speaker_id == s.id,
  #       where: vs.video_id in ^videos_ids,
  #       select: {vs.video_id, s}
  #     )

  #   Enum.group_by(Repo.all(query), &elem(&1, 0), &elem(&1, 1))
  # end

  # def added_by_user(user, paginate_options \\ []) do
  #   Video
  #   |> join(:inner, [v], a in DB.Schema.UserAction, a.video_id == v.id)
  #   |> where([_, a], a.user_id == ^user.id)
  #   |> where([_, a], a.type == ^:add and a.entity == ^:video)
  #   |> DB.Query.order_by_last_inserted_desc()
  #   |> Repo.paginate(paginate_options)
  # end
