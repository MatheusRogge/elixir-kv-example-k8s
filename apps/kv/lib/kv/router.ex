defmodule KV.Router do
  require Logger

  defp get_routing_table(nodes) do
    nodes = nodes()
    node_count = Enum.count(nodes)
    chunks_per_node = div(26, node_count)

    Enum.chunk_every(?a..?z, chunks_per_node) 
      |> Enum.with_index() 
      |> Enum.map(fn {e, i} -> {e, Enum.at(nodes, rem(i, node_count))} end)
  end

  def route(bucket, mod, fun, args) do
    first = :binary.first(bucket)
    entry = Enum.find(nodes(), fn {enum, _node} -> first in enum end) || no_entry_error(bucket)

    if elem(entry, 1) == node() do
      apply(mod, fun, args)
    else
      {KV.RouterTasks, elem(entry, 1)}
        |> Task.Supervisor.async(KV.Router, :route, [bucket, mod, fun, args])
        |> Task.await()
    end
  end

  defp nodes do
    [Node.self() | Node.list()]
  end

  defp no_entry_error(bucket) do
    raise "could not find entry for #{inspect(bucket)} in nodes #{inspect(nodes())}"
  end
end
