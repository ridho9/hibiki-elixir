defmodule Hibiki.Command.Call do
  use Teitoku.Command

  def name, do: "call"

  def description, do: "A simple call"

  def handle(_args, _ctx) do
    :timer.sleep(6000)

    {:reply,
     %LineSdk.Model.TextMessage{
       text: "Roger, Hibiki, heading out!\n\nI'll never forget Tenshi..."
     }}
  end
end
