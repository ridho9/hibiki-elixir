defmodule HibikiWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    port = Application.get_env(:hibiki_web, :port, 8080)

    children = [
      # Starts a worker by calling: HibikiWeb.Worker.start_link(arg)
      # {HibikiWeb.Worker, arg}
      {Plug.Cowboy, scheme: :http, plug: HibikiWeb.Router, options: [port: port]}
    ]

    Logger.info("Starting server at :#{port}")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HibikiWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
