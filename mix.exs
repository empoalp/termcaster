defmodule Termcaster.Mixfile do
  use Mix.Project

  def project do
    [ app: :termcaster,
      version: "0.0.1",
      elixir: "~> 0.12.0",
      deps: deps ]
  end

  def application do
    [ applications: [:cowboy, :bullet],
      mod: { Termcaster, [] }]
  end

  defp deps do
    [ { :bullet, github: "extend/bullet" } ]
  end
end
