defmodule LineSdk.Client do
  @line_api_url "https://api.line.me/v2"

  def send_reply(data, reply_token) when is_map(data), do: send_reply([data], reply_token)

  def send_reply(data, reply_token) do
    messages =
      data
      |> Enum.map(fn x -> LineSdk.MessageObject.to_object(x) end)

    post("/bot/message/reply", %{
      "replyToken" => reply_token,
      "messages" => messages
    })
  end

  def get_content(message_id) do
    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           get("/bot/message/#{message_id}/content") do
      {:ok, body}
    end
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
