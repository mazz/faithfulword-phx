defmodule FaithfulWordApi.Endpoint do
  use Phoenix.Endpoint, otp_app: :faithful_word_api

  socket "/socket", FaithfulWordApi.UserSocket,
    websocket: true,
    longpoll: false

  socket "/live", Phoenix.LiveView.Socket

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :faithful_word_api,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt .well-known)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  plug Plug.RequestId
  plug Plug.Logger
  plug(FaithfulWordApi.SecurityHeaders)

  plug(
    Corsica,
    max_age: 3600,
    allow_headers: ~w(Accept Content-Type Authorization Origin),
    origins: {FaithfulWordApi.CORS, :check_origin}
  )

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    # max_age: 24*60*60*37,       # 37 days
    key: "_faithful_word_api_key",
    signing_salt: "kTTPuGj0"

  plug FaithfulWordApi.Router
end
