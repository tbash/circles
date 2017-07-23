defmodule Circles.Web.UserController do
  use Circles.Web, :controller

  alias Circles.Account
  alias Circles.Account.User

  action_fallback Circles.Web.FallbackController

  def create(conn, user_params) do
    with {:ok, %User{} = user} <- Account.user_from_oauth(user_params),
         token <- Phoenix.Token.sign(conn, "user", user.id),
    do:
      conn
      |> put_status(:created)
      |> render("auth_user.json", %{user: user, token: token})
  end

  # TODO: Allow user to remove themselves
  #
  # def delete(conn, %{"id" => id}) do
  #   user = Account.get_user!(id)
  #   with {:ok, %User{}} <- Account.delete_user(user),
  #   do: send_resp(conn, :no_content, "")
  # end
end
