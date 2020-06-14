defmodule Hibiki.Command.Help do
  use Teitoku.Command
  alias Teitoku.Command.Options, as: Opt

  def name, do: "help"

  def options,
    do:
      %Opt{}
      |> Opt.add_named("query")
      |> Opt.allow_empty()

  def handle(%{"query" => ""}, _ctx) do
    all_command =
      Hibiki.Registry.all()
      |> Enum.map(fn x -> x.name end)
      |> Enum.join(", ")

    text =
      ["Commands list: #{all_command}", "Use '!help <command>' for more details"]
      |> Enum.join("\n")

    {:reply,
     %LineSdk.Model.TextMessage{
       text: text
     }}
  end
end
