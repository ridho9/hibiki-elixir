defmodule Teitoku.Validation do
  def validate_message(body, channel_secret, signature) do
    signature_match =
      LineSdk.Auth.signature_match?(
        body,
        channel_secret,
        signature
      )

    if signature_match do
      {:ok, nil}
    else
      {:error, "invalid signature"}
    end
  end
end
