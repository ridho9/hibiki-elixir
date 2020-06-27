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

  def handle(%{"name" => name}, %{source: source, user: user}) do
    case Tag.get_from_tiered_scope(name, source, user) do
      nil ->
        {:reply_error, "Tag '#{name}' not found in this #{source.type}"}

      %Tag{name: name, value: value, type: type} ->
        {:reply,
         %LineSdk.Model.TextMessage{
           text: "#{name} #{value} #{type}"
         }}
    end
  end
end
