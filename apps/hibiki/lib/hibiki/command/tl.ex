defmodule Hibiki.Command.Tl do
  use Teitoku.Command
  alias Teitoku.Command.Options

  def name, do: "tl"

  def description, do: "Translate (almost) any language to english."

  def options,
    do:
      %Options{}
      |> Options.add_named("query", desc: "sentence to translate")

  def handle(%{"query" => query}, _ctx) do
    url = Hibiki.Config.deepl_proxy() <> "/translate/tl"

    with {:ok, body} <- Jason.encode(%{"src" => query}),
         {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.post(url, body),
         {:ok, %{"result" => result, "src_lang" => src_lang}} <- Jason.decode(body) do
      {:reply,
       %LineSdk.Model.TextMessage{
         text: "#{query} (#{src_lang}) => #{result}"
       }}
    end
  end
end
