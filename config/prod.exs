import Config

config :logger,
  compile_time_purge_matching: [
    [level_lower_than: :info]
  ]

config :hibiki,
  tag: System.fetch_env!("TAG")
