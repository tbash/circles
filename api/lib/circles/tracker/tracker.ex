defmodule Circles.Tracker do
  use GenServer
  require Logger

  alias Circles.Account.User

  @tab :user_positions

  ## Client
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def insert(%User{} = user) do
    :ets.insert(@tab, {user.id, user})
  end

  def list do
    :ets.tab2list(@tab)
  end

  ## Server
  def init(_) do
    :ets.new(@tab, [:set, :named_table, :public, read_concurrency: true,
                                                 write_concurrency: true])

    {:ok, %{}}
  end
end
