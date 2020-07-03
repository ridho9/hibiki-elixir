defmodule Hibiki.Command.Tag.List do
  use Teitoku.Command
  alias Teitoku.Command.Options

  def name, do: "list"

  def description, do: "Lists available tags"

  def options,
    do:
      %Options{}
      |> Options.add_named("keyword", desc: "Keyword to filter")
      |> Options.allow_empty()

  def handle(%{"keyword" => keyword}, %{source: source, user: user}) do
    user_tags = "User: " <> list_tag_in_scope(user, keyword)
    global_tags = "Global: " <> list_tag_in_scope(Hibiki.Entity.global(), keyword)

    scope_tags =
      if source.type in ["group", "room"] do
        String.capitalize(source.type) <> ": " <> list_tag_in_scope(source, keyword)
      end

    result =
      [
        user_tags,
        scope_tags,
        global_tags
      ]
      |> Enum.filter(fn x -> x != nil and x != "" end)
      |> Enum.join("\n\n")

    {:reply,
     %LineSdk.Model.TextMessage{
       text: result
     }}
  end

  defp list_tag_in_scope(scope, keyword) do
    scope
    |> Hibiki.Tag.get_by_scope()
    |> Enum.map(fn x -> x.name end)
    |> Enum.filter(fn s -> String.contains?(s, keyword) end)
    |> Enum.sort()
    |> Enum.join(", ")
    |> case do
      "" -> "no tag found"
      x -> x
    end
  end
end
