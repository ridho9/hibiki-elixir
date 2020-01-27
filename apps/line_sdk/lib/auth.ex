defmodule LineSDK.Auth do
  @doc """
  Calculate x-line-signature for `message` with `channel_secret`
  """
  def calculate_signature(message, channel_secret) do
    :crypto.hmac(:sha256, channel_secret, message)
    |> Base.encode64()
  end

  def signature_match?(message, channel_secret, signature) do
    calculate_signature(message, channel_secret) == signature
  end
end
