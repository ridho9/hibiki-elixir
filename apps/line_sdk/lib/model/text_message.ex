defmodule LineSdk.Model.TextMessage do
  defstruct text: "", id: nil

  @type t :: %__MODULE__{text: String.t(), id: String.t() | nil}
end

defimpl LineSdk.MessageObject, for: LineSdk.Model.TextMessage do
  def to_object(%LineSdk.Model.TextMessage{text: text}) do
    %{
      "type" => "text",
      "text" => text
    }
  end
end
