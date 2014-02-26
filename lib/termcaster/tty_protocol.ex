defmodule Termcaster.TTYProtocol do
  use GenServer.Behaviour
  @behaviour :ranch_protocol

  def start_link(ref, socket, transport, opts) do
    :proc_lib.start_link(__MODULE__, :init, [ref, socket, transport, opts])
  end

  def init(ref, socket, transport, []) do
    :ok = :proc_lib.init_ack({ :ok, self })
    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [active: :once, packet: :raw])
    :gen_server.enter_loop(__MODULE__, [], { socket, transport, <<>> })
  end

  def handle_info({:tcp, socket, data}, { socket, transport, buffer }) do
    :ok = transport.setopts(socket, [active: :once])
    :gen_server.cast(:termcaster, {:ttyin, :base64.encode(data)})
    {:noreply, { socket, transport, <<>> }}
  end

  def handle_info(info, state) do
    {:stop, :normal, state}
  end

end
