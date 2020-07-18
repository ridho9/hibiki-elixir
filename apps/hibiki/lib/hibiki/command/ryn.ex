defmodule Hibiki.Command.Ryn do
  use Teitoku.Command
  alias Teitoku.Command.Options, as: Opt

  def name, do: "ryn"

  def description, do: "Answers yes or no"

  def options,
    do:
      %Opt{}
      |> Opt.add_named("question", desc: "Your question")
      |> Opt.allow_empty()

  def handle(%{"question" => question}, _ctx) do
    answer = Enum.random(["yes", "no", "maybe"])
    msg = String.trim("#{question}\n> #{answer}")

    {:reply,
     %LineSdk.Model.TextMessage{
       text: msg
     }}
  end
end
