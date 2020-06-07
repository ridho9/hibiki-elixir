defmodule Hibiki.Command.Calc do
  use Teitoku.Command
  alias Teitoku.Command.Options

  def name, do: "calc"

  def options,
    do:
      %Options{}
      |> Options.add_named("query")

  def handle(%{"query" => query}, _ctx) do
    case Hibiki.Calc.calculate(query) do
      {:ok, %{"out" => out}} ->
        {:reply,
         %LineSdk.Model.TextMessage{
           text: "#{query} = #{out}"
         }}

      {:error, err} ->
        {:reply_error, err}
    end
  end
end
