defmodule KV.MixProject do
  use Mix.Project

  def project do
    [
      app: :kv,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      env: [routing_table: []],
      mod: {KV, []}
    ]
  end

  defp deps do
    [
      {:libcluster, "~> 3.1"}, 
      {:horde, "~> 0.8.5"}
    ]
  end
end
