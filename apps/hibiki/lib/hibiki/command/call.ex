defmodule Hibiki.Command.Call do
  def name, do: "call"

  def handle(_args) do
    {:reply, %LineSdk.Model.TextMessage{text: "Hello calling"}}
  end
end
