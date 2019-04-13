defmodule Opml.MixProject do
  use Mix.Project

  def project do
    [
      app: :opml,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      dialyzer: [plt_add_deps: :transitive],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        check_all: :test,
        pre_commit: :test
      ],
      test_coverage: [tool: ExCoveralls]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:erlsom, "~> 1.5"},
      # check and documentation libs and tools
      {:credo, "~> 1.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.5", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.20", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: [:test], runtime: false},
      {:inch_ex, "~> 2.0", only: [:dev, :test], runtime: false}
    ]
  end

  defp aliases do
    [
      check_all: ["test", "dialyzer", "credo --strict", "inch", "coveralls"],
      pre_commit: ["format", "docs", "check_all"]
    ]
  end
end
