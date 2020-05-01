defmodule FaithfulWordApi.Metrics do
  use Prometheus.Metric

  # alias FaithfulWordApi.{ZipCode, ZipCodes.ZipCode}

  def setup do
    # Our counter for the number of searches against a particular zipcode.
    # Given that there is a label 'geohash' each zip code gets its own counter.
    Counter.new(
      name: :faithful_word_app_media_item_search,
      help: "Counter for media item searches",
      labels: [:query_string]
    )

    # The provided radius will fall into one of the defined buckets
    # Histogram.new(
    #   name: :elixir_app_radius_search,
    #   buckets: [1, 2, 5, 10, 20, 50],
    #   help: "The radius that people are searching within for breweries"
    # )
  end

  def increment_media_item_search(query_string) do
    Counter.inc(name: :faithful_word_app_media_item_search, labels: [query_string])
  end

  # def observe_radius_search(radius) do
  #   Histogram.observe([name: :elixir_app_radius_search], String.to_integer(radius))
  # end
end
