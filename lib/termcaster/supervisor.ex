defmodule Termcaster.Supervisor do
  use Supervisor.Behaviour

  def start_link do
    :supervisor.start_link(__MODULE__, [])
  end

  def init([]) do
    children = [ 
      worker(Termcaster.Server, [])
    ]

    supervise children, strategy: :one_for_one
  end
end
