defmodule Hibiki.Command.Ryn do
  use Teitoku.Command
  alias Teitoku.Command.Arguments, as: Args

  def name, do: "ryn"

  def description, do: "Answers yes or no"

  def options,
    do:
      %Args{}
      |> Args.add_named("question", desc: "Your question")
      |> Args.allow_empty()

  def handle(%{"question" => question}, _ctx) do
    answer = Enum.random(["yes", "no", "maybe"])
    msg = String.trim("#{question}\n> #{answer}")

    {:reply,
     %LineSdk.Model.TextMessage{
       text: msg
     }}
  end
end
