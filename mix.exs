defmodule IbmFunctionsBase.MixProject do
  use Mix.Project

  def project do
    [
      app: :ibm_functions_base,
      version: "0.1.0",
      elixir: "~> 1.9",
      name: "IbmFunctionsBase",
      description: description(),
      package: package(),
      build_embedded: true,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      source_url: "https://github.com/imahiro-t/ibm_functions_base",
      docs: [
        main: "readme", # The main page in the docs
        extras: ["README.md"]
      ]
    ]
  end

  defp description do
    "Base library to create Elixir IBM Functions"
  end

  defp package do
    [ 
      maintainers: ["erin"],
      licenses: ["MIT"],
      links: %{ "Github" => "https://github.com/imahiro-t/ibm_functions_base" }
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:jason, "~> 1.2"}
    ]
  end
end
