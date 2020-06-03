defmodule Hibiki.Command.Call do
  @behaviour Teitoku.Command

  @impl true
  def name, do: "call"

  @impl true
  def handle(_args, _ctx) do
    {:reply,
     %LineSdk.Model.TextMessage{
       text: "Roger, Hibiki, heading out!\n\nI'll never forget Tenshi..."
     }}
  end
end
