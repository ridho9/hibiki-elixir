# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

config :logger, :console, metadata: [:reply_token, :command, :elapsed_time]

config :hibiki,
  ecto_repos: [Hibiki.Repo]

config :hibiki,
  admin_id: [],
  channel_access_token: nil,
  channel_secret: nil

config :hibiki, Hibiki.Repo,
  database: "hibiki_repo",
  username: "user",
  password: "pass",
  hostname: "localhost"

config :hibiki_web,
  port: 8080

import_config "#{Mix.env()}.exs"
