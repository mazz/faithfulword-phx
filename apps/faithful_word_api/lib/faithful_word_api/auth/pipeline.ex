defmodule FaithfulWordApi.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :faithful_word_api,
    module: FaithfulWordApi.Auth.Guardian,
    error_handler: FaithfulWordApi.Auth.ErrorHandler

  plug(Guardian.Plug.VerifyHeader)
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource)
end
