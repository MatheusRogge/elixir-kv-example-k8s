defmodule BucketGenerator do
    import Logger

    defp send_and_recv(socket, command) do
        :ok = :gen_tcp.send(socket, command)
        :gen_tcp.recv(socket, 0)
    end

    defp send_ok_reply_command(socket, name) do
        case send_and_recv(socket, name) do
            {:ok, "OK\r\n"} -> :ok
            value -> :error
        end
    end

    defp generate_bucket(socket, name) do
        case send_ok_reply_command(socket, "CREATE #{name}\r\n") do
            :ok -> send_ok_reply_command(socket, "PUT #{name} foo 1\r\n")
            :error -> :error
        end
    end

    def generate() do
        opts = [:binary, packet: :line, active: false]
        {:ok, socket} = :gen_tcp.connect('localhost', 8080, opts)

        for i <- 1..100 do
            generate_bucket(socket, "bucket-#{i}")
        end
    end 
end

BucketGenerator.generate