defmodule LineSdk.Client do
  @line_api_url "https://api.line.me/v2"

  def send_reply(reply_token, data) when is_map(data), do: send_reply(reply_token, [data])

  def send_reply(reply_token, data) do
    messages =
      data
      |> Enum.map(fn x -> LineSdk.MessageObject.to_object(x) end)

    post("/bot/message/reply", %{
      "reply_token" => reply_token,
      "messages" => messages
    })
  end

  def get(url) do
    headers = [
      {"Authorization", "Bearer #{LineSdk.Config.channel_access_token()}"}
    ]

    HTTPoison.get(@line_api_url <> url, headers)
  end

  def post(url, data) do
    headers = [
      {"Authorization", "Bearer #{LineSdk.Config.channel_access_token()}"},
      {"Content-Type", "application/json"}
    ]

    with {:ok, data} <- Jason.encode(data) do
      HTTPoison.post(@line_api_url <> url, data, headers)
    end
  end
end
