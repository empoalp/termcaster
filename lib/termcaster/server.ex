defmodule Termcaster.Server do
  use GenServer.Behaviour

  def start_link() do
    :gen_server.start_link({ :local, :termcaster }, __MODULE__, [], [])
  end

  def init([]) do
    { :ok, [] }
  end

  def handle_cast({ :addclient, pid }, clients) do
    { :noreply, [pid|clients] }
  end

  def handle_cast({ :ttyin, data }, clients) do
    send_to_clients(data, clients)
    { :noreply, clients }
  end

  def send_to_clients(data, []), do: :ok
  def send_to_clients(data, [client|rest]) do
    send client, {:ttydata, data}
    send_to_clients(data, rest)
  end

end
