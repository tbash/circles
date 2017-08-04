defmodule Circles.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      supervisor(Circles.Repo, []),
      supervisor(Circles.Web.Endpoint, []),
      supervisor(Circles.Tracker.Supervisor, []),
    ]

    opts = [strategy: :one_for_one, name: Circles.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
