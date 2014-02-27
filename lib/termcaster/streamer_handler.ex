defmodule Termcaster.StreamerHandler do

  def init(_transport, req, opts, _active) do
    { session, req } = :cowboy_req.binding(:session, req)
    { :ok, req, session }
  end

  def stream(data, req, session) do
    :gen_server.cast(:termcaster, {:ttyin, session, :base64.encode(data)})
    {:ok, req, session}
  end

  def info(info, req, session) do
    {:ok, req, session}
  end

  def terminate(req, session) do
    :ok
  end

end
