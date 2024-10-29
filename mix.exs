defmodule Qu.MixProject do
  use Mix.Project

  def project do
    [
      app: :qu,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Qu.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.7.14"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0.0-rc.7", override: true},
      {:floki, ">= 0.30.0", only: :test},
      {:bun, "~> 1.3", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2", runtime: Mix.env() == :dev},
      {:jason, "~> 1.2"},
      {:bandit, "~> 1.5"}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": [
        "tailwind.install --if-missing",
        "bun.install --if-missing",
        "bun default install --cwd assets"
      ],
      "assets.build": ["tailwind qu", "bun qu"],
      "assets.deploy": ["tailwind qu --minify", "bun qu --minify", "phx.digest"]
    ]
  end
end
