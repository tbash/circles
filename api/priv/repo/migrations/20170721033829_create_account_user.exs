defmodule Circles.Repo.Migrations.CreateCircles.Account.User do
  use Ecto.Migration

  def change do
    create table(:account_users) do
      add :background, :string, null: false, default: "000000"
      add :avatar, :string, null: false, default: ""
      add :handle, :string, null: false
      add :twitter_id, :integer, null: false

      timestamps()
    end
    create index(:account_users, [:handle])
    create unique_index(:account_users, [:twitter_id])

  end
end
