defmodule FaithfulWordApi.MixProject do
  use Mix.Project

  def project do
    [
      app: :faithful_word_api,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {FaithfulWordApi.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # {:arc, github: "Betree/arc", override: true},
      # {:arc, "~> 0.11.0"},
      # {:arc_ecto, "~> 0.11.1"},
      # {:httpoison, "~> 1.5.0"},
      # {:google_api_you_tube, "~> 0.2.0"},
      {:kaur, "~> 1.1"},
      {:oauth2, "~> 2.0"},
      {:phoenix, "~> 1.5"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.13"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.17.0"},
      {:jason, "~> 1.1"},
      {:plug_cowboy, "~> 2.1"},
      {:guardian, "~> 2.0"},
      {:comeonin, "~> 5.1"},
      {:bcrypt_elixir, "~> 2.0"},
      {:argon2_elixir, "~> 2.0"},
      {:corsica, "~> 1.1"},
      {:phoenix_live_dashboard, "~> 0.2"},
      # {:prometheus, "~> 4.4.1"},
      # {:prometheus_ex, "~> 3.0.5"},
      # {:prometheus_ecto, "~> 1.4.3"},
      # {:prometheus_phoenix, "~> 1.3.0"},
      # {:prometheus_plugs, "~> 1.1.5"},
      # {:prometheus_process_collector, "~> 1.4.3"},
      # ---- Internal ----
      {:faithful_word, in_umbrella: true},
      {:db, in_umbrella: true}

      # Auth
      # {:sans_password, "~> 1.0.0"},
      # {:recaptcha, "~> 2.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, we extend the test task to create and migrate the database.
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [test: ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
