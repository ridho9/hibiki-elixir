defmodule Hibiki.Command.Call do
  @behaviour Hibiki.Command

  @impl true
  def name, do: "call"

  @impl true
  def handle(_args) do
    {:reply,
     %LineSdk.Model.TextMessage{
       text: "Roger, Hibiki, heading out!\n\nI'll never forget Tenshi..."
     }}
  end
end
