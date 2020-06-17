defimpl Hibiki.Convertable, for: LineSdk.Model.MessageEvent do
  def convert(%LineSdk.Model.MessageEvent{message: message}) do
    Hibiki.Convertable.convert(message)
  end
end

defimpl Hibiki.Convertable, for: LineSdk.Model.TextMessage do
  def convert(%LineSdk.Model.TextMessage{text: text}) do
    {:ok, %Hibiki.Event.Text{text: text}}
  end
end

defimpl Hibiki.Convertable, for: LineSdk.Model.ImageMessage do
  def convert(%LineSdk.Model.ImageMessage{id: id}) do
    {:error, id}
  end
end
