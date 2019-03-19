defmodule FaithfulWord.Videos.MetadataFetcher.Youtube do
  @moduledoc """
  Methods to fetch metadata (title, language) from videos
  """

  @behaviour FaithfulWord.Videos.MetadataFetcher

  require Logger

  alias Kaur.Result
  alias GoogleApi.YouTube.V3.Connection, as: YouTubeConnection
  alias GoogleApi.YouTube.V3.Api.Videos, as: YouTubeVideos
  # alias GoogleApi.YouTube.V3.Api.PlaylistItems, as: YouTubePlaylistItems
  # UCq7BdmVpQsay5XrwOgMhN5w
  alias GoogleApi.YouTube.V3.Model.PlaylistItemListResponse, as: YouTubePlaylistVideos
  alias GoogleApi.YouTube.V3.Model.PlaylistItem, as: YouTubePlaylistVideo


  alias GoogleApi.YouTube.V3.Model.Video, as: YouTubeVideo
  alias GoogleApi.YouTube.V3.Model.VideoListResponse, as: YouTubeVideoList

  alias DB.Schema.Video
  alias FaithfulWord.Videos.MetadataFetcher

  @doc """
  Fetch metadata from video. Returns an object containing  :title, :url and :language
  """
  def fetch_video_metadata(nil),
    do: {:error, "Invalid URL"}

  def fetch_video_metadata(url) when is_binary(url) do
    {:youtube, youtube_id} = Video.parse_url(url)

    case Application.get_env(:faithful_word, :youtube_api_key) do
      nil ->
        Logger.warn("No YouTube API key provided. Falling back to HTML fetcher")
        MetadataFetcher.Opengraph.fetch_video_metadata(url)

      api_key ->
        do_fetch_video_metadata(youtube_id, api_key)
    end
  end

  defp do_fetch_video_metadata(youtube_id, api_key) do
    YouTubeConnection.new()
    |> YouTubeVideos.youtube_videos_list("snippet", id: youtube_id, key: api_key)
    |> Result.map_error(fn e -> "YouTube API Error: #{inspect(e)}" end)
    |> Result.keep_if(&(!Enum.empty?(&1.items)), "remote_video_404")
    |> Result.map(fn %YouTubeVideoList{items: [video = %YouTubeVideo{} | _]} ->
      %{
        title: video.snippet.title,
        language: video.snippet.defaultLanguage || video.snippet.defaultAudioLanguage,
        url: Video.build_url(%{youtube_id: youtube_id})
      }
    end)
  end

  def fetch_playlist_item_list_metadata(nil),
    do: {:error, "Invalid URL"}

  def fetch_playlist_item_list_metadata(playlist_id) when is_binary(playlist_id) do

    case Application.get_env(:faithful_word, :youtube_api_key) do
      nil ->
        Logger.warn("No YouTube API key provided. Bailing")
        # MetadataFetcher.Opengraph.fetch_video_metadata(url)

      api_key ->
        do_fetch_playlist_item_list_metadata(playlist_id, api_key)
    end
  end


  defp do_fetch_playlist_item_list_metadata(playlist_id, api_key) do

    # returns playlistid for sanderson1611
    # %GoogleApi.YouTube.V3.Model.ChannelListResponse{
    # conn |> YouTubeChannels.youtube_channels_list("contentDetails", forUsername: "sanderson1611", key: "AIzaSyB01nsJz0y24aXMqbX34oJ9Y4ywh0koKe4")

    # returns sanderson1611
    # %GoogleApi.YouTube.V3.Model.PlaylistListResponse{
    # conn |> YouTubePlaylists.youtube_playlists_list("snippet", maxResults: 50, id: "UUq7BdmVpQsay5XrwOgMhN5w", key: "AIzaSyB01nsJz0y24aXMqbX34oJ9Y4ywh0koKe4")

    #  GoogleApi.YouTube.V3.Model.PlaylistItemListResponse.yout
    #returns first 50
    # %GoogleApi.YouTube.V3.Model.PlaylistItemListResponse{
    # with
    # items: [%GoogleApi.YouTube.V3.Model.PlaylistItem{ ...}]
    # from main sanderson1611 playlist
    # with pageToken "CDIQAA"
    # conn |> YouTubePlaylistItems.youtube_playlist_items_list("snippet", maxResults: 50, playlistId: "UUq7BdmVpQsay5XrwOgMhN5w", pageToken: "CDIQAA", key: "AIzaSyB01nsJz0y24aXMqbX34oJ9Y4ywh0koKe4")

    thing = YouTubeConnection.new()
    |> GoogleApi.YouTube.V3.Api.PlaylistItems.youtube_playlist_items_list("snippet", maxResults: 50, playlistId: playlist_id, key: api_key)
    |> Result.map_error(fn e -> "YouTube API Error: #{inspect(e)}" end)
    |> Result.keep_if(&(!Enum.empty?(&1.items)), "remote_video_404")
    |> Result.map(fn %GoogleApi.YouTube.V3.Model.PlaylistItemListResponse{items: [video = %GoogleApi.YouTube.V3.Model.PlaylistItem{} | _]} ->
      %{
        title: video.snippet.title,
        language: "en",
        url: Video.build_url(%{youtube_id: video.snippet.resourceId.videoId})
      }
    end)

    # YouTubePlaylistVideo

    IO.inspect(thing)


      # %{
      #   title: video.snippet.title,
      #   language: video.snippet.defaultLanguage || video.snippet.defaultAudioLanguage,
      #   url: Video.build_url(%{channel_id: channel_id})
      # }
  end
end

"""
{:ok,
 %GoogleApi.YouTube.V3.Model.PlaylistItemListResponse{
   etag: "\"XpPGQXPnxQJhLgs6enD_n8JR4Qk/bl5SJ6tbEpq3fHA9eJnn81iUwTk\"",
   eventId: nil,
   items: [
     %GoogleApi.YouTube.V3.Model.PlaylistItem{
       contentDetails: nil,
       etag: "\"XpPGQXPnxQJhLgs6enD_n8JR4Qk/cglhhOWRkcs8ApzRqYnj9UqsF-I\"",
       id: "VVVxN0JkbVZwUXNheTVYcndPZ01oTjV3LlNhYk9WWHVBMHdj",
       kind: "youtube#playlistItem",
       snippet: %GoogleApi.YouTube.V3.Model.PlaylistItemSnippet{
         channelId: "UCq7BdmVpQsay5XrwOgMhN5w",
         channelTitle: "sanderson1611",
         description: "This is an excerpt from the full sermon \"Jesus in the Book of Numbers:\"\n\nhttps://www.youtube.com/watch?v=2fJmO30w6Nk\n\nMore preaching from Pastor Anderson:\n\nhttp://www.faithfulwordbaptist.org/page5.html\n\nHere is the link to make a donation to Faithful Word Baptist Church (donations processed by Word of Truth Baptist Church):\n\nhttp://wordoftruthbaptist.org/donate\n\n#oldtestament\n#ot\n#numbers",
         playlistId: "UUq7BdmVpQsay5XrwOgMhN5w",
         position: 50,
         publishedAt: #DateTime<2019-02-09 16:28:27.000Z>,
         resourceId: %GoogleApi.YouTube.V3.Model.ResourceId{
           channelId: nil,
           kind: "youtube#video",
           playlistId: nil,
           videoId: "SabOVXuA0wc"
         },
         thumbnails: %GoogleApi.YouTube.V3.Model.ThumbnailDetails{
           default: %GoogleApi.YouTube.V3.Model.Thumbnail{
             height: 90,
             url: "https://i.ytimg.com/vi/SabOVXuA0wc/default.jpg",
             width: 120
           },
           high: %GoogleApi.YouTube.V3.Model.Thumbnail{
             height: 360,
             url: "https://i.ytimg.com/vi/SabOVXuA0wc/hqdefault.jpg",
             width: 480
           },
           maxres: %GoogleApi.YouTube.V3.Model.Thumbnail{
             height: 720,
             url: "https://i.ytimg.com/vi/SabOVXuA0wc/maxresdefault.jpg",
             width: 1280
           },
           medium: %GoogleApi.YouTube.V3.Model.Thumbnail{
             height: 180,
             url: "https://i.ytimg.com/vi/SabOVXuA0wc/mqdefault.jpg",
             width: 320
           },
           standard: %GoogleApi.YouTube.V3.Model.Thumbnail{
             height: 480,
             url: "https://i.ytimg.com/vi/SabOVXuA0wc/sddefault.jpg",
             width: 640
           }
         },
         title: "Old Testament Books Have Never Been More Relevant"
       },
       status: nil
     },
"""
