defmodule Hibiki.Command.Case do
  use Teitoku.Command
  alias Teitoku.Command.Options

  def name, do: "case"

  def description, do: "Various string case transformation"

  def options,
    do:
      %Options{}
      |> Options.add_named("query", desc: "Thing to be transformed")
      |> Options.add_flag("u", desc: "To uppercase")
      |> Options.add_flag("l", desc: "To lowercase")
      |> Options.add_flag("c", desc: "Capitalize")
      |> Options.add_flag("m", desc: "Mixed case")

  def handle(%{"query" => query, "u" => u, "l" => l, "c" => c, "m" => m}, _ctx) do
    result =
      cond do
        m ->
          query
          |> String.downcase()
          |> String.codepoints()
          |> Enum.map_every(2, fn x -> String.upcase(x) end)
          |> Enum.join()

        u ->
          String.upcase(query)

        l ->
          String.downcase(query)

        c ->
          String.capitalize(query)

        true ->
          query
      end

    {:reply,
     %LineSdk.Model.TextMessage{
       text: result
     }}
  end
end
