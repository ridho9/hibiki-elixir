defmodule Hibiki.Command.Call do
  use Teitoku.Command

  def name, do: "call"

  def handle(_args, _ctx) do
    {:reply,
     %LineSdk.Model.TextMessage{
       text: "Roger, Hibiki, heading out!\n\nI'll never forget Tenshi..."
     }}
  end
end
