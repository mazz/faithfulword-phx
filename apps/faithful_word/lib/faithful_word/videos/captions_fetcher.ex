defmodule FaithfulWord.Videos.CaptionsFetcher do
  @moduledoc """
  Fetch captions for videos.
  """

  @callback fetch(FaithfulWord.DB.Schema.Video.t()) :: {:ok, FaithfulWord.DB.Schema.VideoCaption.t()} | {:error, binary()}
end
