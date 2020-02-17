defmodule Hibiki.Validation do
  def validate_message(body, signature) do
    signature_match =
      LineSdk.Auth.signature_match?(
        body,
        Application.get_env(:hibiki, :channel_secret),
        signature
      )

    if signature_match do
      {:ok, nil}
    else
      {:error, "invalid signature"}
    end
  end
end
