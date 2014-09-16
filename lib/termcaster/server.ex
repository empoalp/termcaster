defmodule Termcaster.Server do
  use GenServer

  @moduledoc """
    This is the termcaster main server
    It is responsable for creating and storing new sessions
  """

  def start_link() do
    # start main server as a named process :termcaster
    :gen_server.start_link({ :local, :termcaster }, __MODULE__, [], [])
  end

  def init([]) do
    # create a hash to store the session processes by session_id
    sessions = HashDict.new
    { :ok, sessions }
  end

  @doc """
    Creates a new termcaster session
  """
  def handle_call(:newsession, _from, sessions) do

    # generates a random id for the session
    <<num::size(64)>> = :crypto.strong_rand_bytes(8)
    session_id = Integer.to_string(num)

    # start a new process to handle the session
    { :ok, session_pid } = Termcaster.Session.start_link

    # store the new session in the session hash dict
    sessions = HashDict.put(sessions, session_id, session_pid)

    { :reply, session_id, sessions }
  end

  @doc """
    Returns the session process id for given session id
  """
  def handle_call({ :getsessionpid, session_id }, _from, sessions) do
    { :reply, sessions[session_id], sessions }
  end

end
