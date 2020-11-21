defmodule LibOpus.MixProject do
  use Mix.Project

  def project do
    [
      compilers: [:elixir_make] ++ Mix.compilers(),
      app: :lib_opus,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      make_cwd: "c_src"
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
      {:elixir_make, "~> 0.6", runtime: false},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      files: [
        "mix.exs",
        "lib",
        "c_src/**/{*.c,*.cpp,*.h,*.hpp,Makefile,*.makefile}",
      ],
      maintainers: ["Adrian Parvin D. Ouano"],
    ]
  end
end
