import Config

config :hibiki,
  admin_id: ["admin_id"],
  channel_access_token: "channel access token",
  channel_secret: "channel secret",
  deepl_proxy: "deepl proxy, ignore",
  nhen_cookie: "cookie"

config :hibiki,
  tag: "DEV"

config :hibiki_web,
  port: 8080

config :hibiki, Hibiki.Repo,
  database: "hibiki",
  username: "postgres",
  password: "docker",
  hostname: "localhost"
