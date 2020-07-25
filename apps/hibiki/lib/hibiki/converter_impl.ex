defimpl Hibiki.Convertable, for: LineSdk.Model.MessageEvent do
  alias LineSdk.Model.Source
  alias Hibiki.Entity

  def convert(%LineSdk.Model.MessageEvent{message: message, source: source}, ctx) do
    user_entity = source |> Source.user_id() |> Entity.create_or_get("user")

    source_entity =
      case source do
        %LineSdk.Model.SourceGroup{group_id: source_id} ->
          Entity.create_or_get(source_id, "group")

        %LineSdk.Model.SourceRoom{room_id: source_id} ->
          Entity.create_or_get(source_id, "room")

        %LineSdk.Model.SourceUser{} ->
          user_entity
      end

    ctx =
      ctx
      |> Map.put(:source, source_entity)
      |> Map.put(:user, user_entity)

    Hibiki.Convertable.convert(message, ctx)
  end
end

defimpl Hibiki.Convertable, for: LineSdk.Model.TextMessage do
  def convert(%LineSdk.Model.TextMessage{text: text}, ctx) do
    {:ok, %Hibiki.Event.Text{text: text}, ctx}
  end
end

defimpl Hibiki.Convertable, for: LineSdk.Model.ImageMessage do
  def convert(%LineSdk.Model.ImageMessage{id: id}, ctx) do
    {:ok, %Hibiki.Event.Image{id: id}, ctx}
  end
end
