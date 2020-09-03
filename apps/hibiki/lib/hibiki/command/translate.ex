defmodule Hibiki.Command.Translate do
  use Teitoku.Command
  alias Teitoku.Command.Options
  require Logger

  def name, do: "tl"

  def description, do: "Translate (almost) any language to english."

  def options,
    do:
      %Options{}
      |> Options.add_named("query", desc: "sentence to translate")

  def handle(%{"query" => query}, _ctx) do
    with {:ok, %{"result" => result, "src_lang" => src_lang}} <- Hibiki.Translate.translate(query) do
      {:reply,
       %LineSdk.Model.TextMessage{
         text: "#{query} (#{src_lang}) => #{result}"
       }}
    end
  end
end
