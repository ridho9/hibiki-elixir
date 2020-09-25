defmodule LineSdk.Model.WebhookEvent do
  defstruct destination: "", events: []

  @type t :: %__MODULE__{destination: String.t(), events: list(LineSdk.Model.event())}
end
