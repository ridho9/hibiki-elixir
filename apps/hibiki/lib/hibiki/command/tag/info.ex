defmodule Hibiki.Command.Tag.Info do
  use Teitoku.Command
  alias Teitoku.Command.Options
  alias Hibiki.Tag
  alias Hibiki.Entity

  def name, do: "info"

  def description, do: "Get tag info"

  def options,
    do:
      %Options{}
      |> Options.add_named("name", desc: "tag name")
      |> Options.add_flag("!", desc: "Search from global scope", name: "global?")
      |> Options.add_flag("s", desc: "Search from group/room scope", name: "scope?")

  def prehandle,
    do: [
      &Hibiki.Command.Tag.Create.check_added/2
    ]

  def handle(%{"name" => name} = args, ctx) do
    scope = Hibiki.Command.Tag.resolve_scope(args, ctx)

    Tag.get_from_tiered_scope(name, scope)
    |> Hibiki.Repo.preload([:creator, :scope])
    |> case do
      nil ->
        [%Entity{type: scope_type} | _] = scope
        {:reply_error, "Tag '#{name}' not found in this #{scope_type}"}

      %Tag{
        id: tag_id,
        type: type,
        scope: scope,
        creator: %Entity{line_id: creator_id} = creator
      } ->
        with {:ok, %{"displayName" => display_name}} <-
               LineSdk.Client.get_profile(Hibiki.Config.client(), creator_id) do
          msg =
            [
              "[ #{name} ]",
              "Created by: #{display_name}",
              "Type: #{type}",
              "Scope: #{scope.type}",
              "#{tag_id}:#{creator.id}:#{scope.id}"
            ]
            |> Enum.filter(fn x -> x != nil end)
            |> Enum.join("\n")

          {:reply, %LineSdk.Model.TextMessage{text: msg}}
        end
    end
  end
end
