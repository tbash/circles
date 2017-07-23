defmodule Circles.Web.ApplicationController do
  use Circles.Web, :controller

  def not_found(conn, _) do
    conn
    |> put_status(:not_found)
    |> render(Circles.Web.ErrorView, "404.json")
  end

  def ok(conn, _) do
    conn
    |> put_status(:ok)
    |> json(%{ok: true})
  end
end
