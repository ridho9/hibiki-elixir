defmodule Hibiki.Command.Tag.Create do
  use Teitoku.Command
  alias Teitoku.Command.Options
  alias Hibiki.Tag

  def name, do: "create"

  def description, do: "A simple call"

  def options,
    do:
      %Options{}
      |> Options.add_named("name", desc: "tag name")
      |> Options.add_named("value", desc: "tag value")
      |> Options.add_flag("t", desc: "create text tag", name: "text")
      |> Options.add_flag("!", hidden: true, name: "global")

  def handle(%{"name" => name, "value" => value, "text" => text, "global" => global}, %{
        source: source,
        user: user
      }) do
    type =
      if text do
        "text"
      else
        "image"
      end

    # TODO: Check if user is admin
    scope =
      if global do
        Hibiki.Entity.global()
      else
        source
      end

    creator = user
    name = String.trim(name)

    case Tag.create(name, type, value, creator, scope) do
      {:ok, tag} ->
        {:reply,
         %LineSdk.Model.TextMessage{
           text: "Successfully created tag '#{tag.name}' in this #{scope.type}"
         }}

      {:error, err} ->
        {:reply_error, "Error creating tag '#{name}': " <> Tag.format_error(err)}
    end
  end
end
