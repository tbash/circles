defmodule Circles.Web.PositionChannel do
  use Circles.Web, :channel

  alias Circles.Tracker
  alias Circles.Account

  def join("position:lobby", payload, socket) do
    {:ok, socket}
  end

  def handle_in("list:users", _, socket) do
    users = Tracker.list()

    {:reply, {:ok, users}, socket}
  end

  def insert_and_broadcast(user, socket, msg) do
    Tracker.insert(user)

    broadcast(socket, msg, %{
      user: %{
        id: user.id,
        background: user.background,
        avatar: user.avatar,
        handle: user.handle,
        x: user.x,
        y: user.y,
      }
    })

    {:noreply, socket}
  end

  def handle_in("new:user" = msg, _, socket) do
    socket.assigns.current_user
    |> insert_and_broadcast(socket, msg)
  end

  def handle_in("new:position" = msg, %{"x" => x, "y"=> y}, socket) do
    socket.assigns.current_user
    |> Account.update_position({x, y})
    |> insert_and_broadcast(socket, msg)
  end
end
