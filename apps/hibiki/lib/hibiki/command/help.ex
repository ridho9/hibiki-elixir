defmodule Hibiki.Command.Help do
  use Teitoku.Command
  alias Teitoku.Command.Options, as: Opt
  alias Hibiki.Help

  def name, do: "help"

  def description, do: "When you don't know what things do"

  def options,
    do:
      %Opt{}
      |> Opt.add_named("query", desc: "Command name")
      |> Opt.allow_empty()

  def handle(%{"query" => ""}, _ctx) do
    all_command =
      Hibiki.Registry.subcommands()
      |> Enum.filter(fn x -> x.private == false end)
      |> Enum.map(fn x -> x.name end)
      |> Enum.sort()
      |> Enum.join(", ")

    text =
      ["Commands list: #{all_command}", "Use '!help <command>' for more details"]
      |> Enum.join("\n")

    {:reply,
     %LineSdk.Model.TextMessage{
       text: text
     }}
  end

  def handle(%{"query" => query}, _ctx) do
    case Teitoku.Command.Registry.resolve_command(Hibiki.Registry, query) do
      {:ok, command, _, parent} ->
        text =
          [
            Help.gen_usage(command, parent),
            "  " <> command.description,
            Help.gen_flag_desc(command),
            Help.gen_usage_desc(command),
            Help.gen_subcommands(command)
          ]
          |> Enum.filter(fn x -> x != "" end)
          |> Enum.join("\n")

        {:reply,
         %LineSdk.Model.TextMessage{
           text: text
         }}

      {:error, err} ->
        {:reply_error, err}
    end
  end
end
