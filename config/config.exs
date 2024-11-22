# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :bday,
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :bday, BdayWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: BdayWeb.ErrorHTML, json: BdayWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Bday.PubSub,
  live_view: [signing_salt: "8RXSOksQ"]

# Configure bun (the version is required)
config :bun,
  version: "1.1.33",
  bday: [
    args: ~w(
      build js/app.js
        --outdir=../priv/static/assets
        --external /fonts/*
        --external /images/*
    ),
    cd: Path.expand("../assets", __DIR__),
    env: %{}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "4.0.0-beta.2",
  bday: [
    args: ~w(
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
