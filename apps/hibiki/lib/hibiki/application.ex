defmodule Hibiki.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Telemetry.Metrics

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: Hibiki.Worker.start_link(arg)
      # {Hibiki.Worker, arg}
      {Cachex, name: Hibiki.Cache},
      {Hibiki.Entity.Data, name: Hibiki.Entity.Data},
      # {Hibiki.Cache, name: Hibiki.Cache},
      {Hibiki.Repo, []},
      {TelemetryMetricsPrometheus, [metrics: metrics()]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hibiki.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def metrics do
    [
      sum(
        "hibiki.command.microseconds.total",
        event_name: "hibiki.command.finish",
        measurement: :duration,
        tags: [:command]
      ),
      counter(
        "hibiki.command.total",
        event_name: "hibiki.command.finish",
        measurement: :duration,
        tags: [:command]
      )
    ]
  end
end
