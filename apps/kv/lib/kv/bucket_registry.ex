defmodule KV.BucketRegistry do
    use Horde.Registry

    def start_link(opts) do
        name = Keyword.get(opts, :name, __MODULE__)
        Horde.Registry.start_link(__MODULE__, [keys: :unique], name: name)
    end

    @impl true
    def init(opts) do
        [members: members()]
        |> Keyword.merge(opts)
        |> Horde.Registry.init()
    end

    def register(name, pid) do
        Horde.Registry.register(__MODULE__, name, pid)
    end

    def unregister(name) do
        Horde.Registry.unregister(__MODULE__, name)
    end

    def lookup(name) do
        Horde.Registry.lookup(__MODULE__, name)
    end

    defp members() do
        Enum.map([Node.self() | Node.list()], &{__MODULE__, &1})
    end
end