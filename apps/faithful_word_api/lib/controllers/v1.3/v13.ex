defmodule FaithfulWordApi.V13 do

  import Ecto.Query, warn: false
  alias DB.Repo
  alias DB.Schema.Book
  alias DB.Schema.LanguageIdentifier

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

  def version() do
    "1.3"
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
