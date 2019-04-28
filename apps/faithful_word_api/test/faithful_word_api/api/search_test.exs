defmodule FaithfulWordApi.SearchTest do
  use FaithfulWordApi.ConnCase

  alias FaithfulWordApi.MediaItemsSearch

  require Logger

  test "convert bible abbreviation" do
    for  {k, v}  <- MediaItemsSearch.abbreviations()  do
      search_string = "Colossians"
      # search_string =~ abbrev |> String.downcase do
      downcased_abbrev = k |> String.downcase
      if Regex.match?( ~r/\b#{downcased_abbrev}\b/ , search_string) do
        Logger.info("found #{downcased_abbrev} for #{v}")
        new_search_string = Regex.replace(~r/\b#{v}\b/, search_string, k)
        Logger.info("new_search_string #{new_search_string}")
      end
    end
  end
end

