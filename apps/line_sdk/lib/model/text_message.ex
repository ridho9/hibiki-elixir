defmodule LineSdk.Model.TextMessage do
  defstruct text: "", id: nil

  @type t :: %__MODULE__{text: String.t(), id: String.t() | nil}
end
