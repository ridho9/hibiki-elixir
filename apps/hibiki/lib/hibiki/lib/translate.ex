defmodule Hibiki.Translate do
  def translate(query) do
    url = Hibiki.Config.deepl_proxy() <> "/translate/tl"

    http_config = [
      hackney: [pool: :tl],
      recv_timeout: 30_000,
      timeout: 30_000
    ]

    with {:ok, body} <- Jason.encode(%{"src" => query}),
         {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.post(url, body, [], http_config),
         {:ok, result} <- Jason.decode(body) do
      {:ok, result}
    end
  end
end
