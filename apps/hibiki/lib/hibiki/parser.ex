defmodule Hibiki.Parser do
  def parse_webhook_message(false, _headers) do
    {:error, "no body"}
  end

  def parse_webhook_message(_body, nil) do
    {:error, "missing x-line-signature"}
  end

  def parse_webhook_message(body, signature) do
    signature_match =
      LineSdk.Auth.signature_match?(
        body,
        Application.get_env(:hibiki, :channel_secret),
        signature
      )

    cond do
      signature_match == false ->
        {:error, "signature invalid"}

      true ->
        with {:ok, body} <- Jason.decode(body),
             {:ok, body} <- LineSdk.Decoder.decode(body) do
          {:ok, body}
        end
    end
  end
end
