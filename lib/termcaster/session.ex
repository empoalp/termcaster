defmodule Termcaster.Session do
  use GenServer

  defmodule SessionState do
    defstruct clients: [], 
      control_clients: [],
      paused: false,
      size: {80, 24}
  end

  def start_link(), do: :gen_server.start_link(__MODULE__, [], [])
  def init([]), do: { :ok, %SessionState{} }

  def handle_cast({ :addclient, pid }, state) do
    { :noreply, %{state | clients: [pid|state.clients]} }
  end

  def handle_cast({ :addcontrolclient, pid }, state) do
    { :noreply, %{state | control_clients: [pid|state.control_clients]} }
  end

  def handle_cast({ :ttyin, data }, state) do
    send_data(data, state.clients)
    { :noreply, state }
  end

  def handle_cast({ :controlin, data }, state) do
    send_control(data, state.control_clients)
    { :noreply, state }
  end

  def send_data(_data, []), do: :ok
  def send_data(data, [client|rest]) do
    send client, {:ttydata, data}
    send_data(data, rest)
  end

  def send_control(_data, []), do: :ok
  def send_control(data, [client|rest]) do
    send client, {:controldata, data}
    send_control(data, rest)
  end

end
