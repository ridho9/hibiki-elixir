defmodule Hibiki.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Hibiki.Worker.start_link(arg)
      # {Hibiki.Worker, arg}
      {Hibiki.Repo, []},
      {Hibiki.Cache, name: Hibiki.Cache}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hibiki.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
