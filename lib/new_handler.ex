defmodule Termcaster.NewHandler do

  def init(_transport, req, []) do
    {:ok, req, nil}
  end

  def handle(req, state) do
    session_id = :gen_server.call(:termcaster, :newsession)
    {:ok, req} = :cowboy_req.reply(200, [], session_id, req)
    {:ok, req, state}
  end

  def terminate(_reason, _req, _state), do: :ok

end
