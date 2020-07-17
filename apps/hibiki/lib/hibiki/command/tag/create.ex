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

  def prehandle, do: [&load_global/2]

  def handle(%{"name" => name, "value" => value, "text" => text, "global" => global}, %{
        source: source,
        user: user
      }) do
    # TODO: Check if user is admin
    scope =
      if global do
        Hibiki.Entity.global()
      else
        source
      end

    type =
      if text do
        "text"
      else
        "image"
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

  def load_global(%{"global" => false} = args, ctx) do
    {:ok, args, ctx}
  end

  def load_global(%{"global" => true} = args, %{source: source} = ctx) do
    if source.line_id in Hibiki.Config.admin_id() do
      ctx = %{ctx | source: Hibiki.Entity.global()}
      {:ok, args, ctx}
    else
      {:error, "you are not an admin"}
    end
  end
end
