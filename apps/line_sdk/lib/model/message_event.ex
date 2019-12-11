defmodule LineSdk.Model.MessageEvent do
  defstruct id: "",
            message: nil,
            timestamp: nil,
            reply_token: "",
            source: nil

  @type t :: %__MODULE__{
          id: String.t(),
          message: LineSdk.Model.message_object(),
          timestamp: DateTime.t(),
          reply_token: String.t(),
          source: LineSdk.Model.Source.t()
        }
end
