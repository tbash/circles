defmodule Circles.Web.RequestOauthController do
  use Circles.Web, :controller

  action_fallback Circles.Web.FallbackController

  def show(conn, _) do
    with token <- ExTwitter.request_token(),
         {:ok, auth_url} <- ExTwitter.authenticate_url(token.oauth_token),
    do:
      conn
      |> put_status(:ok)
      |> json(%{authenticate_url: auth_url})
  end
end
