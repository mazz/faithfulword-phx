defmodule FaithfulWordApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do

  # Start all the instrumenters
  FaithfulWordApi.PhoenixInstrumenter.setup()
  FaithfulWordApi.PipelineInstrumenter.setup()
  FaithfulWordApi.RepoInstrumenter.setup()
  FaithfulWordApi.PrometheusExporter.setup()

  # NOTE: Only for FreeBSD, Linux and OSX (experimental)
  # https://github.com/deadtrickster/prometheus_process_collector
  Prometheus.Registry.register_collector(:prometheus_process_collector)

  :telemetry.attach(
    "prometheus-ecto",
    [:elixir_monitoring_prom, :repo, :query],
    &FaithfulWordApi.RepoInstrumenter.handle_event/4,
    nil
  )
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      FaithfulWordApi.Endpoint
      # Starts a worker by calling: FaithfulWordApi.Worker.start_link(arg)
      # {FaithfulWordApi.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FaithfulWordApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FaithfulWordApi.Endpoint.config_change(changed, removed)
    :ok
  end
end
