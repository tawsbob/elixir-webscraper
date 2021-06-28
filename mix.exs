defmodule Webscraper.MixProject do
  use Mix.Project

  def project do
    [
      app: :webscraper,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

       # Docs
      name: "elixir-webscraper",
      source_url: "https://github.com/tawsbob/elixir-webscraper",
      homepage_url: "http://YOUR_PROJECT_HOMEPAGE",
      docs: [
        main: "elixir-webscraper", # The main page in the docs
        #logo: "path/to/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:floki, "~> 0.30.0"},
      {:tesla, "~> 1.4.0"},
      {:hackney, "~> 1.17.0"},
      {:slugify, "~> 1.3"},
      {:json, "~> 1.4.1"},
      {:ex_doc, "~> 0.24", only: :dev, runtime: false},
    ]
  end
end
