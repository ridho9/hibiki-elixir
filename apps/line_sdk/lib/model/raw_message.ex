defmodule LineSdk.Model.RawMessage do
  defstruct content: nil

  @type t :: %__MODULE__{content: any()}
end

defimpl LineSdk.MessageObject, for: LineSdk.Model.RawMessage do
  def to_object(%LineSdk.Model.RawMessage{content: content}) do
    content
  end
end
