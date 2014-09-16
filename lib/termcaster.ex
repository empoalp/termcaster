defmodule Termcaster do
  use Application

  def start(_type, _args) do    

    routes = [
      {"/", :cowboy_static, {:file, "static/index.html"}},
      {"/newsession", Termcaster.NewHandler, []},
      {"/js/bullet.js", :cowboy_static, {:priv_file, :bullet, "bullet.js"}},
      {"/js/[...]", :cowboy_static, {:dir, "static/js"}},
      {"/streamer/:session", :bullet_handler,
          [handler: Termcaster.StreamerHandler]},
      {"/streamer_control/:session", :bullet_handler,
          [handler: Termcaster.StreamerControlHandler]},
      {"/watcher/:session", :bullet_handler,
          [handler: Termcaster.WatcherHandler ]},
      {"/watcher_control/:session", :bullet_handler,
          [handler: Termcaster.WatcherControlHandler ]}
    ]

    dispatch = :cowboy_router.compile([{ :_, routes }])

    {:ok, _} = :cowboy.start_http(:http, 100,
                                   [port: 8080],
                                   [env: [dispatch: dispatch]])

    Termcaster.Supervisor.start_link
  end
end
