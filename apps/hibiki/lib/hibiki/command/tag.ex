defmodule Hibiki.Command.Tag do
  use Teitoku.Command
  alias Teitoku.Command.Options, as: Opt
  alias Hibiki.Tag

  def name, do: "tag"

  def description, do: "A simple call"

  def options,
    do:
      %Opt{}
      |> Opt.add_named("name", desc: "Tag name")
      |> Opt.add_flag("r", desc: "Raw value")

  def handle(%{"name" => name, "r" => raw}, %{source: source, user: user}) do
    case Tag.get_from_tiered_scope(name, source, user) do
      nil ->
        {:reply_error, "Tag '#{name}' not found in this #{source.type}"}

      %Tag{value: value, type: type} ->
        msg =
          cond do
            raw || type == "text" ->
              %LineSdk.Model.TextMessage{
                text: value
              }

            type == "image" ->
              %LineSdk.Model.ImageMessage{
                preview_url: value,
                original_url: value
              }
          end

        {:reply, msg}
    end
  end

  def subcommands,
    do: [
      Hibiki.Command.Tag.Create
    ]
end
