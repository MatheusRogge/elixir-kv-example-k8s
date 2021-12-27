defmodule KvUmbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [
        kv_server: [
          version: "0.0.1",
          include_executables_for: [:unix],
          applications: [kv_server: :permanent, kv: :permanent]
        ]
      ]
    ]
  end

  defp deps do
    []
  end
end
