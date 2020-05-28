defmodule Hibiki.Command.Call do
  @behaviour Hibiki.Command

  @impl true
  def name, do: "call"

  @impl true
  def handle(_args) do
    {:reply, %LineSdk.Model.TextMessage{text: "Hello calling"}}
  end
end
