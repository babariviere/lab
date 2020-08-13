defmodule EchoServer do
  require Logger

  def serve do
    {:ok, listen_socket} = :gen_tcp.listen(8080, [:binary, active: true, reuseaddr: true])
    Logger.info("Listening on 8080")

    for _ <- 0..2, do: spawn(fn -> server_handler(listen_socket) end)
  end

  def server_handler(listen_socket) do
    {:ok, socket} = :gen_tcp.accept(listen_socket)
    IO.inspect(socket)

    Logger.info("new connection")
    client_handler(socket)
    server_handler(listen_socket)
  end

  def client_handler(socket) do
    receive do
      {:tcp, ^socket, data} ->
        :ok = :gen_tcp.send(socket, data)
        client_handler(socket)

      _ ->
        nil
    end
  end
end

EchoServer.serve()
Process.sleep(:infinity)
