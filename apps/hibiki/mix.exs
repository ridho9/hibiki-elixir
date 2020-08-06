defmodule Hibiki.MixProject do
  use Mix.Project

  def project do
    [
      app: :hibiki,
      version: "1.11.1",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Hibiki.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true}
      {:httpoison, "~> 1.6"},
      {:tesla, "~> 1.3.0"},
      {:jason, "~> 1.1"},
      {:temp, "~> 0.4.7"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:line_sdk, in_umbrella: true},
      {:teitoku, in_umbrella: true}
    ]
  end
end
