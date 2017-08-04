defmodule Circles.Account do
  @moduledoc """
  The boundary for the Account system.
  """

  import Ecto.Query, warn: false
  alias Circles.Repo

  alias Circles.Account.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def upsert_user(%{
    handle: handle,
    twitter_id: twitter_id,
    avatar: avatar,
    background: background,
  }) do
    Repo.insert!(%User{
        handle: handle,
        twitter_id: twitter_id,
        avatar: avatar,
        background: background,
      },
      on_conflict: [set: [
        handle: handle,
        twitter_id: twitter_id,
        avatar: avatar,
        background: background,
      ]],
      conflict_target: :twitter_id
    )
  end

  def user_from_oauth(%{
    "oauth_token" => oauth_token,
    "oauth_verifier" => oauth_verifier
  }) do
    case ExTwitter.access_token(oauth_verifier, oauth_token) do
      {:ok, access_token} ->
        ExTwitter.configure(
          :process,
          Enum.concat(
            ExTwitter.Config.get_tuples,
            [ access_token: access_token.oauth_token,
              access_token_secret: access_token.oauth_token_secret ]
          )
        )

        user_data = ExTwitter.verify_credentials()

        upsert_user(%{
          handle: user_data.screen_name,
          twitter_id: user_data.id,
          avatar: user_data.profile_image_url_https,
          background: user_data.profile_link_color,
        })
      _ ->
        :error
    end
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  # NOTE: For now, these are some bounds to validate and correct against
  @min 0
  @max 900

  def update_position(%User{} = user, {x, y} \\ {0, 0}) do
    %{user | x: correct_point(x), y: correct_point(y)}
  end

  ## Internal
  defp correct_point(p) do
    cond do
      p > @max ->
        @min

      p < @min ->
        @max

      true ->
        p
    end
  end
end
