defmodule Hibiki.Command.Tag do
  use Teitoku.Command
  alias Teitoku.Command.Arguments, as: Args
  alias Hibiki.Tag
  alias Hibiki.Entity

  def name, do: "tag"

  def description, do: "A simple call"

  def options,
    do:
      %Args{}
      |> Args.add_named("name", desc: "Tag name")
      |> Args.add_flag("r", desc: "Raw value")
      |> Args.add_flag("!", desc: "Search from global scope", name: "global?")
      |> Args.add_flag("s", desc: "Search from group/room scope", name: "scope?")

  def handle(%{"name" => name, "r" => raw} = args, ctx) do
    scope = resolve_scope(args, ctx)

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

  def resolve_scope(%{"global?" => global?, "scope?" => scope?}, %{source: source, user: user}) do
    cond do
      global? ->
        [Hibiki.Entity.global()]

      scope? ->
        [source, Hibiki.Entity.global()]

      true ->
        [user, source, Hibiki.Entity.global()]
    end
  end

  def subcommands,
    do: [
      Hibiki.Command.Tag.Create,
      Hibiki.Command.Tag.Upload,
      Hibiki.Command.Tag.List,
      Hibiki.Command.Tag.Info,
      Hibiki.Command.Tag.Delete
    ]
end
