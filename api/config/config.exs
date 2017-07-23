# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :circles,
  ecto_repos: [Circles.Repo]

# Configures the endpoint
config :circles, Circles.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0ehzMr9r/U+/6MiTF9ydUMKeM19mz/dQ9DquAcu2/0s4T1M5qq8KQrw2XMZQxJQ6",
  render_errors: [view: Circles.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Circles.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
