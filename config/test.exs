import Config

config :hibiki,
  admin_id: ["admin"],
  channel_access_token: "cat",
  channel_secret: "secret"

config :hibiki_web,
  port: 8080

config :hibiki, Hibiki.Repo,
  database: "hibiki_test",
  username: "postgres",
  password: "docker",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
