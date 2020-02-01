defmodule FaithfulWordApi.PhoenixInstrumenter do
  @moduledoc "Prometheus instrmenter for Phoenix"

  use Prometheus.PhoenixInstrumenter
end

defmodule FaithfulWordApi.PipelineInstrumenter do
  @moduledoc "Prometheus instrmenter for Phoenix"

  use Prometheus.PlugPipelineInstrumenter

  def label_value(:request_path, conn) do
    case Phoenix.Router.route_info(
           FaithfulWordApi.Router,
           conn.method,
           conn.request_path,
           ""
         ) do
      %{route: path} -> path
      _ -> "unkown"
    end
  end
end

defmodule FaithfulWordApi.RepoInstrumenter do
  @moduledoc "Prometheus instrmenter for Phoenix"

  use Prometheus.EctoInstrumenter
end

defmodule FaithfulWordApi.PrometheusExporter do
  @moduledoc "Prometheus instrmenter for Phoenix"

  use Prometheus.PlugExporter
end


defmodule FaithfulWordApi.PipelineInstrumenter do
  @moduledoc "Prometheus instrmenter for Phoenix"

  use Prometheus.PlugPipelineInstrumenter

  def label_value(:request_path, conn) do
    case Phoenix.Router.route_info(
      FaithfulWordApi.Router,
           conn.method,
           conn.request_path,
           ""
         ) do
      %{route: path} -> path
      _ -> "unknown catchall"
    end
  end
end
