defmodule Hibiki.Event.Image do
  @type t :: %__MODULE__{id: String.t()}
  defstruct id: ""
end

defimpl Teitoku.HandleableEvent, for: Hibiki.Event.Image do
  def handle(%Hibiki.Event.Image{id: id}, %{source: source}) do
    # {:reply,
    #  %LineSdk.Model.TextMessage{
    #    text: "image id #{id}"
    #  }}

    source
    |> Hibiki.Entity.from_source()
    |> Hibiki.Entity.Data.set(Hibiki.Entity.Data.Key.last_image_id(), id)

    {:ignore, nil}
  end
end
