defmodule SonarCoverageElixir.Mixfile do
  use Mix.Project

  def project do
    [
      app: :sonar_coverage_elixir,
      version: "0.1.0",
      elixir: "~> 1.0",
      deps: [],
      description: description(),
      package: [],
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp description do
    """
    A plugin for `mix test --cover` that writes a `generic_coverage.xml` file
    compatible with SonarQube
    """
  end
end
