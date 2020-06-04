defmodule Hibiki.Command.Call do
  alias Teitoku.Command.Options

  @behaviour Teitoku.Command

  def name, do: "call"

  def options, do: %Options{}

  def handle(_args, _ctx) do
    {:reply,
     %LineSdk.Model.TextMessage{
       text: "Roger, Hibiki, heading out!\n\nI'll never forget Tenshi..."
     }}
  end
end
