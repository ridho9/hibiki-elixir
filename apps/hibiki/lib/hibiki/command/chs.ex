defmodule Hibiki.Command.Chs do
  use Teitoku.Command
  alias Teitoku.Command.Arguments

  def name, do: "chs"

  def description, do: "Choose!"

  def options,
    do:
      %Arguments{}
      |> Arguments.add_named("choice", desc: "Choices to select from, separated by space")
      |> Arguments.tokenize_last()

  def handle(%{"choice" => choice}, _ctx) do
    select =
      choice
      |> Enum.random()

    {:reply,
     %LineSdk.Model.TextMessage{
       text: select
     }}
  end
end
