defmodule FaithfulWordApi.MediaItemsSearch do

  import Ecto.Query

  def run(query, search_string) do
    _run(query, normalize(search_string))
  end

  defmacro matching_media_items_and_score(search_string) do
    quote do
      fragment(
        """
        SELECT id, presented_at, localizedname, presenter_name, source_material, ts_rank(
          weighted_tsv, plainto_tsquery(unaccent(?))
        ) AS score
        FROM mediaitems
        WHERE weighted_tsv @@ plainto_tsquery(unaccent(?))
        ORDER BY ts_rank(weighted_tsv, plainto_tsquery(unaccent(?))) DESC
        """,
        ^unquote(search_string),
        ^unquote(search_string),
        ^unquote(search_string)
      )
    end
  end

  defp _run(query, ""), do: query
  defp _run(query, search_string) do
    from media_item in query,
      join: id_and_score in matching_media_items_and_score(search_string),
      on: id_and_score.id == media_item.id,
      order_by: [desc: id_and_score.score]
  end

  defp normalize(search_string) do
    search_string
    |> String.downcase
    |> String.replace(~r/\n/, " ")
    |> String.replace(~r/\t/, " ")
    |> String.replace(~r/\s{2,}/, " ")
    |> String.trim
  end

end
