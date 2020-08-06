import Config

config :hibiki,
  admin_id: System.fetch_env!("ADMIN_ID") |> String.split(","),
  channel_access_token: System.fetch_env!("CHANNEL_ACCESS_TOKEN"),
  channel_secret: System.fetch_env!("CHANNEL_SECRET"),
  deepl_proxy: System.fetch_env!("DEEPL_PROXY")

config :hibiki_web,
  port: 8080

config :hibiki, Hibiki.Repo,
  database: System.fetch_env!("DB_NAME"),
  username: System.fetch_env!("DB_USERNAME"),
  password: System.fetch_env!("DB_PASSWORD"),
  hostname: System.fetch_env!("DB_HOSTNAME")
