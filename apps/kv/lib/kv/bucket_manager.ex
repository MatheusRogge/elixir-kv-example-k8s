defmodule KV.BucketManager do
    use GenServer

    def start_link(opts) do
        name = Keyword.get(opts, :name, __MODULE__)
        GenServer.start_link(__MODULE__, opts, name: name)
    end

    @impl true
    def init(_) do
        {:ok, %{}}
    end

    @impl true
    def handle_call({:create, name}, _from, refs) do
        child_spec = %{
            id: KV.Bucket,
            start: {KV.Bucket, :start_link, [name: {:via, Horde.Registry, {KV.BucketRegistry, name}}]}
        }

        case lookup(name) do
            {:ok, pid} -> 
                {:reply, {:ok, pid}, refs}

            :error ->
                {:ok, pid} = KV.BucketSupervisor.start_child(child_spec)
                {:ok, _} = KV.BucketRegistry.register(name, pid)

                ref = Process.monitor(pid)
                refs = Map.put(refs, ref, name)

                {:reply, {:ok, pid}, refs}
        end
    end

    @impl true
    def handle_info({:DOWN, ref, :process, _pid, _reason}, refs) do
        {name, refs} = Map.pop(refs, ref)
        {:ok} = KV.BucketRegistry.unregister(name)

        {:noreply, refs}
    end

    def create(name) do
        GenServer.call(__MODULE__, {:create, name})
    end

    def lookup(name) do
        case KV.BucketRegistry.lookup(name) do
            [{_, pid}] -> {:ok, pid}
            _ -> :error
        end
    end
    
end