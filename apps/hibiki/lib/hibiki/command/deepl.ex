defmodule Hibiki.Command.Deepl do
  use Teitoku.Command
  alias Teitoku.Command.Options

  use Tesla
  plug(Tesla.Middleware.BaseUrl, Hibiki.Config.deepl_proxy())
  plug(Tesla.Middleware.JSON)

  def name, do: "deepl"

  def description, do: "Translate (almost) any language to english. Powered by DeepL."

  def options,
    do:
      %Options{}
      |> Options.add_named("query", desc: "sentence to translate")

  def handle(%{"query" => query}, _ctx) do
    with {:ok,
          %Tesla.Env{
            body: %{"result" => result, "src_lang" => src_lang}
          }} <-
           post("/translate/tl", %{"src" => query}) do
      {:reply,
       %LineSdk.Model.TextMessage{
         text: "#{query} (#{src_lang}) => #{result}"
       }}
    end
  end
end
