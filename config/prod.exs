import Config

config :logger,
  level: :info

config :hibiki,
  tag: System.fetch_env!("TAG")
