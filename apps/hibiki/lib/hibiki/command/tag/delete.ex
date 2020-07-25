defmodule Hibiki.Command.Tag.Delete do
  use Teitoku.Command
  alias Teitoku.Command.Options
  alias Hibiki.Tag
  alias Hibiki.Entity

  def name, do: "delete"

  def description, do: "Delete tag"

  def options,
    do:
      %Options{}
      |> Options.add_named("name", desc: "tag name")
      |> Options.add_flag("!", desc: "Search from global scope", name: "global?")
      |> Options.add_flag("s", desc: "Search from group/room scope", name: "scope?")

  def prehandle,
    do: [
      &Hibiki.Command.Tag.Create.check_added/2,
      &Hibiki.Command.Tag.Create.load_global/2
    ]

  def handle(%{"name" => name, "global?" => global?} = args, ctx) do
    scope = Hibiki.Command.Tag.resolve_scope(args, ctx)

    Tag.get_from_tiered_scope(name, scope)
    |> Hibiki.Repo.preload([:scope])
    |> case do
      nil ->
        [%Entity{type: scope_type} | _] = scope
        {:reply_error, "Tag '#{name}' not found in this #{scope_type}"}

      %Tag{scope: %Entity{type: type} = scope} = tag ->
        if scope == Entity.global() and !global? do
          {:reply_error, "Can't delete global tag without flag"}
        else
          case Tag.delete(tag) do
            {:ok, _} ->
              {:reply,
               %LineSdk.Model.TextMessage{text: "Successfully deleted tag '#{name}' from #{type}"}}

            {:error, err} ->
              {:reply_error, "Error deleting tag: #{Tag.format_error(err)}"}
          end
        end
    end
  end
end
