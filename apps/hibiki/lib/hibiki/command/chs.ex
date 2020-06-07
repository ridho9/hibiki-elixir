defmodule Hibiki.Command.Chs do
  use Teitoku.Command
  alias Teitoku.Command.Options

  def name, do: "chs"

  def options, do: %Options{} |> Options.add_named("choice")

  def handle(%{"choice" => choice}, _ctx) do
    select =
      choice
      |> Teitoku.Token.tokenize()
      |> IO.inspect()
      |> Enum.random()

    {:reply,
     %LineSdk.Model.TextMessage{
       text: select
     }}
  end
end
