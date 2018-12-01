defmodule FaithfulWordApi.Session.GuardianPipeline do
  @moduledoc """
  Main pipeline for Guardian set-up on each request.
  """

  use Guardian.Plug.Pipeline, otp_app: :faithful_word_api

  alias FaithfulWordApi.Session.CurrentUser

  plug Guardian.Plug.Pipeline,
    module: FaithfulWordApi.Auth.Guardian,
    error_handler: FaithfulWordApi.LoginController

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug CurrentUser
end
