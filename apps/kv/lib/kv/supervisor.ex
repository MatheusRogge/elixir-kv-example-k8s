defmodule KV.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def topologies() do
    Application.fetch_env!(:libcluster, :topologies)
  end

  @impl true
  def init(:ok) do
    children = [
      {Cluster.Supervisor, [topologies(), [name: KV.ClusterSupervisor]]},
      {KV.ClusterTopologyObserver, name: KV.ClusterTopologyObserver},
      {KV.BucketSupervisor, name: KV.BucketSupervisor},
      {KV.BucketRegistry, name: KV.BucketRegistry},
      {KV.BucketManager, name: KV.BucketManager},
      {Task.Supervisor, name: KV.RouterTasks},
    ]

    Supervisor.init(children, strategy: :one_for_all)
  end
end
