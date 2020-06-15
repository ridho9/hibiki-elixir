import Config

config :hibiki_web,
  port: 8080

config :line_sdk,
  channel_access_token: "cat",
  channel_secret: "secret"

config :hibiki, Hibiki.Repo,
  database: "hibiki_test",
  username: "postgres",
  password: "docker",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
