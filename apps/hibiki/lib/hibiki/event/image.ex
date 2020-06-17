defmodule Hibiki.Event.Image do
  @type t :: %__MODULE__{id: String.t()}
  defstruct id: ""
end

defimpl Teitoku.HandleableEvent, for: Hibiki.Event.Image do
  @spec handle(any) :: Teitoku.Event.result()
  def handle(%Hibiki.Event.Image{id: _id}) do
    # {:reply,
    #  %LineSdk.Model.TextMessage{
    #    text: "image id #{id}"
    #  }}

    {:ignore, nil}
  end
end
