defmodule Termcaster.StreamerControlHandler do

  def init(_transport, req, _opts, _active) do
    { session_id, req } = :cowboy_req.binding(:session, req)
    session_pid = :gen_server.call(:termcaster, {:getsessionpid, session_id})
    { :ok, req, session_pid }
  end

  def stream(data, req, session_pid) do
    :gen_server.cast(session_pid, {:controlin, data });
    {:ok, req, session_pid}
  end

  def info(_info, req, session_pid), do: {:ok, req, session_pid}
  def terminate(_req, _session_pid), do: :ok

end
