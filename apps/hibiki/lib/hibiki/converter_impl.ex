defimpl Hibiki.Convertable, for: LineSdk.Model.MessageEvent do
  def convert(%LineSdk.Model.MessageEvent{message: message, source: source}, ctx) do
    ctx =
      ctx
      |> Map.put(:source, source)

    Hibiki.Convertable.convert(message, ctx)
  end
end

defimpl Hibiki.Convertable, for: LineSdk.Model.TextMessage do
  def convert(%LineSdk.Model.TextMessage{text: text}, ctx) do
    {:ok, %Hibiki.Event.Text{text: text}, ctx}
  end
end

defimpl Hibiki.Convertable, for: LineSdk.Model.ImageMessage do
  def convert(%LineSdk.Model.ImageMessage{id: id}, _ctx) do
    {:error, id}
  end
end
