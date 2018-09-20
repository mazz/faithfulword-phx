defmodule OlivetreeWeb.Plugs.GuardianPipeline do
  @moduledoc """
  Main pipeline for Guardian set-up on each request.
  """

  use Guardian.Plug.Pipeline, otp_app: :olivetree

  alias OlivetreeWeb.Plugs.CurrentUser

  plug Guardian.Plug.Pipeline,
    module: OlivetreeWeb.Guardian,
    error_handler: OlivetreeWeb.LoginController

  plug Guardian.Plug.VerifySession
  plug Guardian.Plug.VerifyHeader
  plug Guardian.Plug.LoadResource, allow_blank: true

  plug CurrentUser
end
