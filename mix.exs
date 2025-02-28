defmodule MasterOfMalt.MixProject do
  use Mix.Project

  def project do
    [
      app: :master_of_malt,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: [
        {:floki, "~> 0.30"},
        {:httpoison, "~> 1.7"},
        {:credo, "~> 1.5.4", only: [:dev, :test], runtime: false}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end
end
