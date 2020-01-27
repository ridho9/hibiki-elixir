defmodule HibikiWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: HibikiWeb.Worker.start_link(arg)
      # {HibikiWeb.Worker, arg}
      {Ace.HTTP.Service,
       [{HibikiWeb.Router, %{}}, [port: Application.get_env(:hibiki_web, :port), cleartext: true]]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HibikiWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
