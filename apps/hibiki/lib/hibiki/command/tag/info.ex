defmodule Hibiki.Command.Tag.Info do
  use Teitoku.Command
  alias Teitoku.Command.Arguments
  alias Hibiki.Tag
  alias Hibiki.Entity

  def name, do: "info"

  def description, do: "Get tag info"

  def options,
    do:
      %Arguments{}
      |> Arguments.allow_empty()
      |> Arguments.add_named("name", desc: "tag name")
      |> Arguments.add_flag("!", desc: "Search from global scope", name: "global?")
      |> Arguments.add_flag("s", desc: "Search from group/room scope", name: "scope?")

  def prehandle,
    do: [
      &Hibiki.Command.Tag.Create.check_added/2
    ]

  def handle(%{"name" => ""}, %{source: source, user: user} = _ctx) do
    global = Hibiki.Entity.global()

    msg =
      [user, source, global]
      |> Enum.map(fn scope ->
        %Hibiki.Entity{type: scope_type} = scope
        tags = Tag.get_by_scope(scope) |> length()
        String.capitalize(scope_type) <> ": " <> "#{tags} tag(s)"
      end)
      |> Enum.join("\n")

    {:reply, %LineSdk.Model.TextMessage{text: msg}}
  end

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
        creator: %Entity{line_id: creator_id} = creator,
        updated_at: updated_at
      } ->
        with {:ok, %{"displayName" => display_name}} <-
               LineSdk.Client.get_profile(Hibiki.Config.client(), creator_id) do
          local_timezone = Timex.Timezone.local()

          local_updated =
            updated_at
            |> DateTime.from_naive!(local_timezone.full_name, Tzdata.TimeZoneDatabase)
            |> DateTime.shift_zone!("Asia/Jakarta", Tzdata.TimeZoneDatabase)
            |> DateTime.to_string()

          msg =
            [
              "[ #{name} ]",
              "Created by: #{display_name}",
              "Type: #{type}",
              "Scope: #{scope.type}",
              "Updated at: #{local_updated}",
              "#{tag_id}:#{creator.id}:#{scope.id}"
            ]
            |> Enum.filter(fn x -> x != nil end)
            |> Enum.join("\n")

          {:reply, %LineSdk.Model.TextMessage{text: msg}}
        end
    end
  end
end
