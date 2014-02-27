defmodule Termcaster.WatcherHandler do

  def init(_transport, req, opts, _active) do
    { session, req } = :cowboy_req.binding(:session, req)
    :gen_server.cast(:termcaster, {:addclient, session, self}) 
    {:ok, req, []}
  end

  def stream(data, req, state) do
    {:ok, req, state}
  end

  def info({:ttydata, data}, req, state) do
    {:reply, data, req, state} 
  end

  def info(info, req, state) do
    {:ok, req, state}
  end

  def terminate(req, state) do
    :ok
  end

end
