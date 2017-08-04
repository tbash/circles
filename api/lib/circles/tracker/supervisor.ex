defmodule Circles.Tracker.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      worker(Circles.Tracker, [[name: Circles.Tracker]]),
    ]

    supervise(children, strategy: :one_for_one)
  end
end
