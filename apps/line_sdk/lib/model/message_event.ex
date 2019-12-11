defmodule LineSdk.Model.MessageEvent do
  defstruct message: nil,
            timestamp: nil,
            reply_token: "",
            source: nil

  @type t :: %__MODULE__{
          message: LineSdk.Model.message_object(),
          timestamp: DateTime.t(),
          reply_token: String.t(),
          source: LineSdk.Model.Source.t()
        }
end
