defimpl Hibiki.Convertable, for: LineSdk.Model.MessageEvent do
  alias LineSdk.Model.Source

  def convert(%LineSdk.Model.MessageEvent{message: message, source: source}, ctx) do
    ctx =
      ctx
      |> Map.put(:source, source |> Source.id() |> Hibiki.Entity.get())
      |> Map.put(:user, source |> Source.user_id() |> Hibiki.Entity.get())

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
