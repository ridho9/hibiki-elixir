defmodule LineSdk.Model.SourceGroup do
  defstruct group_id: "",
            user_id: nil

  @type t :: %__MODULE__{group_id: String.t(), user_id: String.t() | nil}
end
