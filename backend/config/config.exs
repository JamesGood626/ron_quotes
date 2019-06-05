# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :ron_quotes, RonQuotesWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "zoFt5jQH7M3moPJ+dRyp9sPuALdnLjC3Z7oM1gteaG6baisyRIM40vToeNCHbvx8",
  render_errors: [view: RonQuotesWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: RonQuotes.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
