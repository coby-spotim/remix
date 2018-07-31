defmodule Remix.Mixfile do
  use Mix.Project

  def project do
    [
      app: :updated_remix,
      version: "0.1.0",
      elixir: "~> 1.6",
      package: package(),
      description: description(),
      deps: deps()
    ]
  end

  def application() do
    [applications: [:logger], mod: {Remix.Application, []}]
  end

  defp deps(), do: []

  defp package() do
    [
      licenses: ["MIT"],
      maintainers: ["Coby Benveniste"],
      links: %{
        "GitHub" => "https://github.com/coby-spotim/remix"
      }
    ]
  end

  defp description() do
    """
    A fork of the original remix package which fixes several errors from the old version, which hasn't been updated since 2016.
    Original Description: Recompiles mix projects on any change to the lib directory.
    """
  end
end
