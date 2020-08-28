defmodule Hibiki.Command.Info do
  use Teitoku.Command

  def name, do: "info"

  def description, do: "A simple call"

  def private, do: true

  def handle(_args, _ctx) do
    msg = ~s([Hibiki - #{Hibiki.tag}]
Made by Ridho Pratama & Gabriel B. Raphael.
Powered by Elixir.)

    {:reply,
     %LineSdk.Model.TextMessage{
       text: msg
     }}
  end
end
