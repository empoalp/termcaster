defmodule Termcaster.Server do
  use GenServer.Behaviour

  def start_link() do
    :gen_server.start_link({ :local, :termcaster }, __MODULE__, [], [])
  end

  def init([]) do
    { :ok, HashDict.new }
  end

  def handle_call(:newsession, _from, sessions) do
    <<num::size(64)>> = :crypto.strong_rand_bytes(8)
    session_id = integer_to_binary(num)
    { :reply, session_id, HashDict.put(sessions, session_id, []) }
  end

  def handle_cast({ :addclient, session, pid }, sessions) do
    clients = sessions[session]
    { :noreply, HashDict.put(sessions, session, [pid|clients]) }
  end

  def handle_cast({ :ttyin, session, data }, sessions) do
    send_to_clients(data, sessions[session])
    { :noreply, sessions }
  end

  def send_to_clients(data, []), do: :ok
  def send_to_clients(data, [client|rest]) do
    send client, {:ttydata, data}
    send_to_clients(data, rest)
  end
  def send_to_clients(data, _), do: :error

end
