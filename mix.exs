defmodule Remix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :remixed_remix,
      version: "2.0.2",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      package: package(),
      name: "RemixedRemix",
      source_url: "https://github.com/probably-not/remix",
      description: description(),
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      dialyzer: [plt_add_deps: [:project], plt_add_apps: [:mix, :ex_unit]]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [extra_applications: [:logger], mod: {RemixedRemix.Application, []}]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps, do: []

  defp package do
    [
      description: description(),
      # These are the default files included in the package
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      licenses: ["MIT"],
      maintainers: ["Coby Benveniste"],
      links: %{
        "GitHub" => "https://github.com/probably-not/remix"
      }
    ]
  end

  defp description do
    """
    A fork of the original remix package which fixes several errors from the old version, which hasn't been updated since 2016.
    Original Description: Recompiles mix projects on any change to the lib directory.
    """
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
