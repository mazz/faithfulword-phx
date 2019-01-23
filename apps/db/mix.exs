defmodule DB.MixProject do
  use Mix.Project

  def project do
    [
      app: :db,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      compilers: Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {DB.Application, []},
      extra_applications: [:logger, :ecto, :postgrex]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:ex_aws, "~> 2.1"},
      {:ex_aws_s3, "~> 2.0"},
      {:arc, "~> 0.11.0"},
      {:arc_ecto, "~> 0.11.0"},
      {:ecto_enum, "~> 1.1"},
      {:xml_builder, "~> 2.0", override: true},
      {:slugger, "~> 0.3"},
      {:comeonin, "~> 4.1"},
      {:bcrypt_elixir, "~> 1.1"},
      {:burnex, "~> 1.1"},
      {:hashids, "~> 2.0"},
      {:kaur, "~> 1.1"},
      {:mime, "~> 1.2"},
      {:scrivener_ecto, "~> 2.0"}

      # Dev only
      # {:exsync, "~> 0.2", only: :dev},

      # Test only
      # {:ex_machina, "~> 2.0", only: [:dev, :test]},
      # {:faker, "~> 0.7", only: [:dev, :test]},
      # {:stream_data, "~> 0.1", only: :test}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true},
    ]
  end
end
