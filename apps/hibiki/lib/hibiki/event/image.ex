defmodule Hibiki.Event.Image do
  @type t :: %__MODULE__{id: String.t()}
  defstruct id: ""
end

defimpl Teitoku.HandleableEvent, for: Hibiki.Event.Image do
  def handle(%Hibiki.Event.Image{id: id}) do
    {:reply,
     %LineSdk.Model.TextMessage{
       text: "image id #{id}"
     }}
  end
end
