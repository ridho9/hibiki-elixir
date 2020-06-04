defmodule Hibiki.Command.Calc do
  alias Teitoku.Command.Options

  @behaviour Teitoku.Command

  def name, do: "calc"

  def options, do: %Options{}

  def handle(query, _ctx) do
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
