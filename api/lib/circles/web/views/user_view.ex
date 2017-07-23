defmodule Circles.Web.UserView do
  use Circles.Web, :view
  alias Circles.Web.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      background: user.background,
      avatar: user.avatar,
      handle: user.handle
    }
  end

  def render("auth_user.json", %{user: user, token: token}) do
    %{
      id: user.id,
      background: user.background,
      avatar: user.avatar,
      handle: user.handle,
      token: token,
    }
  end
end
