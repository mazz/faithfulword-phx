defmodule FaithfulWord.Videos.CaptionsFetcher do
  @moduledoc """
  Fetch captions for videos.
  """

  @callback fetch(Db.Schema.Video.t()) :: {:ok, Db.Schema.VideoCaption.t()} | {:error, binary()}
end
