defmodule KV.ClusterTopologyObserver do
    use GenServer
    require Logger

    def start_link(_) do
        GenServer.start_link(__MODULE__, [])
    end

    @impl true
    def init(_) do
        :net_kernel.monitor_nodes(true, node_type: :visible)
        {:ok, nil}
    end

    @impl true
    def handle_info({:nodedown, node, _node_type}, state) do
        set_members(KV.BucketRegistry)
        set_members(KV.BucketSupervisor)

        {:noreply, state}
    end

    @impl true
    def handle_info({:nodeup, node, _node_type}, state) do
        set_members(KV.BucketRegistry)
        set_members(KV.BucketSupervisor)

        {:noreply, state}
    end

    defp set_members(name) do
        members = Enum.map([Node.self() | Node.list()], &{name, &1})
        :ok = Horde.Cluster.set_members(name, members)
    end
end