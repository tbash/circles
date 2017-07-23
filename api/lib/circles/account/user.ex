defmodule Circles.Account.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Circles.Account.User


  schema "account_users" do
    field :avatar, :string
    field :background, :string
    field :handle, :string
    field :twitter_id, :integer

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:background, :avatar, :handle, :twitter_id])
    |> validate_required([:background, :avatar, :handle, :twitter_id])
  end
end
