defmodule Hibiki.Command.Info do
  use Teitoku.Command

  def name, do: "info"

  def description, do: "A simple call"

  def private, do: true

  def handle(_args, ctx) do
    {:reply,
     %LineSdk.Model.TextMessage{
       text: "#{inspect(ctx)}"
     }}
  end
end
