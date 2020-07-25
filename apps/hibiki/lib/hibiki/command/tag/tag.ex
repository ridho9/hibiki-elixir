defmodule Hibiki.Command.Tag do
  use Teitoku.Command
  alias Teitoku.Command.Options, as: Opt
  alias Hibiki.Tag
  alias Hibiki.Entity

  def name, do: "tag"

  def description, do: "A simple call"

  def options,
    do:
      %Opt{}
      |> Opt.add_named("name", desc: "Tag name")
      |> Opt.add_flag("r", desc: "Raw value")
      |> Opt.add_flag("!", desc: "Search from global scope")
      |> Opt.add_flag("s", desc: "Search from group/room scope")

  def handle(%{"name" => name, "r" => raw, "!" => global, "s" => group}, %{
        source: source,
        user: user
      }) do
    scope =
      cond do
        global ->
          [Hibiki.Entity.global()]

        group ->
          [source, Hibiki.Entity.global()]

        true ->
          [user, source, Hibiki.Entity.global()]
      end

    case Tag.get_from_tiered_scope(name, scope) do
      nil ->
        [%Entity{type: scope_type} | _] = scope
        {:reply_error, "Tag '#{name}' not found in this #{scope_type}"}

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
      Hibiki.Command.Tag.Create,
      Hibiki.Command.Tag.List
    ]
end
