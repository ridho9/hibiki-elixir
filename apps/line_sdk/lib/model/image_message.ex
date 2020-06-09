defmodule LineSdk.Model.ImageMessage do
  defstruct id: nil, provider: "", original_url: nil, preview_url: nil

  @type t :: %__MODULE__{
          id: String.t() | nil,
          provider: String.t(),
          original_url: String.t() | nil,
          preview_url: String.t() | nil
        }
end

defimpl LineSdk.MessageObject, for: LineSdk.Model.ImageMessage do
  def to_object(%LineSdk.Model.ImageMessage{original_url: orig, preview_url: prev}) do
    %{
      "type" => "image",
      "originalContentUrl" => orig,
      "previewImageUrl" => prev
    }
  end
end
