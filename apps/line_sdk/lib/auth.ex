defmodule LineSdk.Auth do
  @doc """
  Calculate x-line-signature for `message` with `channel_secret`
  """
  def calculate_signature(message, channel_secret) do
    :crypto.mac(:hmac, :sha256, channel_secret, message)
    |> Base.encode64()
  end

  def signature_match?(message, channel_secret, signature) do
    IO.inspect([message, channel_secret, signature])
    calculate_signature(message, channel_secret) == signature
  end

  def validate_message(body, channel_secret, signature) do
    signature_match?(
      body,
      channel_secret,
      signature
    )
    |> if do
      {:ok, nil}
    else
      {:error, "invalid signature"}
    end
  end
end
