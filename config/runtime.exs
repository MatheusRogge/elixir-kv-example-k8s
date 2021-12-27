import Config

if config_env() == :prod do
  config :kv, :routing_table, [{?a..?z, node()}]

  config :libcluster, topologies: [
    default: [
      strategy: Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: "kv-server-nodes",
        application_name: "kv_server",
        polling_interval: 1_000
      ]
    ]
  ]
else
  config :kv, :routing_table, [{?a..?z, node()}]

  config :libcluster, topologies: [
    default: [
      strategy: Cluster.Strategy.Epmd,
      config: [hosts: [node()]],
    ]
  ]
end