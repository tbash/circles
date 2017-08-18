defmodule Circles.Web.Router do
  use Circles.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Circles.Web do
    pipe_through :api

    resources "/users",         UserController,
                                only: [:create] # , :delete]
    resources "/request_oauth", RequestOauthController,
                                only: [:show], singleton: true

    get "/",      ApplicationController, :ok
    get "/*path", ApplicationController, :not_found
  end
end
