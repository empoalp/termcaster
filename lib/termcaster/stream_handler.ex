defmodule Termcaster.StreamHandler do

  def init(_transport, req, opts, _active) do
    :gen_server.cast(:termcaster, {:addclient, self}) 
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
