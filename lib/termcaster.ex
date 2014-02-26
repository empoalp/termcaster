defmodule Termcaster do
  use Application.Behaviour

  def start(_type, _args) do    

    {:ok, _} = :ranch.start_listener(:ttylistener, 1, :ranch_tcp,
                                      [port: 5555], Termcaster.TTYProtocol, [])

    routes = [
      {"/", :cowboy_static, {:file, "static/index.html"}},
      {"/js/bullet.js", :cowboy_static, {:priv_file, :bullet, "bullet.js"}},
      {"/js/[...]", :cowboy_static, {:dir, "static/js"}},
      {"/bullet", :bullet_handler, [handler: Termcaster.StreamHandler ]}
    ]

    dispatch = :cowboy_router.compile([{ :_, routes }])

    {:ok, _} = :cowboy.start_http(:http, 100,
                                   [port: 8080],
                                   [env: [dispatch: dispatch]])

    Termcaster.Supervisor.start_link
  end
end
