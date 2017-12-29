# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :partypeli,
  ecto_repos: [Partypeli.Repo]

# Configures the endpoint
config :partypeli, PartypeliWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "noVHpy+c0AbMghqQ6iZgi+dfxHweb/t51iuusYnvvYzcORtUAA6TlKPz27dWCniq",
  render_errors: [view: PartypeliWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Partypeli.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
