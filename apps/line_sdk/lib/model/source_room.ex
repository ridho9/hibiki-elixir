defmodule LineSdk.Model.SourceRoom do
  defstruct room_id: "",
            user_id: nil

  @type t :: %__MODULE__{room_id: String.t(), user_id: String.t() | nil}
end
