defmodule FaithfulwordWeb.Plugs.GuardianPipeline do
  @moduledoc """
  Main pipeline for Guardian set-up on each request.
  """

  use Guardian.Plug.Pipeline, otp_app: :faithfulword

  alias FaithfulwordWeb.Plugs.CurrentUser

  plug Guardian.Plug.Pipeline,
    module: FaithfulwordWeb.Guardian,
    error_handler: FaithfulwordWeb.LoginController

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug CurrentUser
end
