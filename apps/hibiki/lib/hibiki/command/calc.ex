defmodule Hibiki.Command.Calc do
  use Teitoku.Command
  alias Teitoku.Command.Arguments

  def name, do: "calc"

  def description, do: "Calculate query, powered by https://web2.0calc.com/"

  def options,
    do:
      %Arguments{}
      |> Arguments.add_named("query", desc: "Equation to calculate")
      |> Arguments.add_flag("i", desc: "Return result as image")

  def handle(%{"query" => query, "i" => image}, _ctx) do
    case Hibiki.Calc.calculate(query) do
      {:ok, result} ->
        handle_success(result, query, image)

      {:error, err} ->
        {:reply_error, err}
    end
  end

  def handle_success(%{"out" => out}, query, false) do
    {:reply,
     %LineSdk.Model.TextMessage{
       text: "#{query} = #{out}"
     }}
  end

  def handle_success(%{"img64" => img}, _query, true) do
    with {:ok, url} <- Hibiki.Upload.upload_base64(Hibiki.Upload.Provider.Kryk, img) do
      {:reply,
       %LineSdk.Model.ImageMessage{
         original_url: url,
         preview_url: url
       }}
    end
  end
end
