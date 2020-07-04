import Config

config :hibiki,
  admin_id: ["Uf013e46b99285f29439f42bd5170992a"],
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
