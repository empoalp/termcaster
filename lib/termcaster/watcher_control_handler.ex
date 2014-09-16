defmodule Termcaster.WatcherControlHandler do

  def init(_transport, req, _opts, _active) do
    { session_id, req } = :cowboy_req.binding(:session, req)
    session_pid = :gen_server.call(:termcaster, {:getsessionpid, session_id})
    :gen_server.cast(session_pid, {:addcontrolclient, self}) 
    {:ok, req, []}
  end

  def stream(_data, req, state), do: {:ok, req, state}
  def info({:controldata, data}, req, state), do: {:reply, data, req, state} 
  def info(_info, req, state), do: {:ok, req, state}
  def terminate(_req, _state), do: :ok

end
