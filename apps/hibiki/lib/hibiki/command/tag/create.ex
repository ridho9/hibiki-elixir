defmodule Hibiki.Command.Tag.Create do
  use Teitoku.Command
  alias Teitoku.Command.Arguments
  alias Hibiki.Tag

  def name, do: "create"

  def description, do: "Create tag"

  def options,
    do:
      %Arguments{}
      |> Arguments.add_named("name", desc: "tag name")
      |> Arguments.add_named("value", desc: "tag value")
      |> Arguments.add_flag("t", desc: "create text tag", name: "text?")
      |> Arguments.add_flag("!", hidden: true, name: "global?")

  def prehandle,
    do: [
      &load_global/2,
      &check_added/2
    ]

  def handle(%{"name" => name, "value" => value, "text?" => text?}, %{
        source: source,
        user: user
      }) do
    type =
      if text? do
        "text"
      else
        "image"
      end

    creator = user
    name = String.trim(name) |> String.downcase()

    case Tag.create(name, type, value, creator, source) do
      {:ok, tag} ->
        {:reply,
         %LineSdk.Model.TextMessage{
           text: "Successfully created tag '#{tag.name}' in this #{source.type}"
         }}

      {:error, err} ->
        {:reply_error, "Error creating tag '#{name}': " <> Tag.format_error(err)}
    end
  end

  def load_global(%{"global?" => false} = args, ctx) do
    {:ok, args, ctx}
  end

  def load_global(
        %{"global?" => true} = args,
        %{user: %Hibiki.Entity{line_id: user_id}} = ctx
      ) do
    if user_id in Hibiki.Config.admin_id() do
      ctx = %{ctx | source: Hibiki.Entity.global()}
      {:ok, args, ctx}
    else
      {:error, "you are not an admin"}
    end
  end

  def check_added(args, %{user: %Hibiki.Entity{line_id: user_id}} = ctx) do
    case LineSdk.Client.get_profile(Hibiki.Config.client(), user_id) do
      {:ok, _} ->
        {:ok, args, ctx}

      {:error, _} ->
        {:error, "please add hibiki first"}
    end
  end
end
