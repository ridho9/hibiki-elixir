defmodule Hibiki.Converter do
  @spec convert_event(any) :: {:ok, any} | {:error, any}
  def convert_event(%LineSdk.Model.MessageEvent{message: %LineSdk.Model.TextMessage{text: text}}) do
    {:ok, %Hibiki.Event.Text{text: text}}
  end

  def convert_event(%LineSdk.Model.MessageEvent{message: %LineSdk.Model.ImageMessage{id: id}}) do
    {:ok, %Hibiki.Event.Image{id: id}}
  end

  def convert_event(event) do
    {:error, event}
  end
end
