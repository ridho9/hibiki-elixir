defmodule LineSdk.Client do
  alias LineSdk.Client
  @line_api_url "https://api.line.me/v2"

  @type t :: %__MODULE__{channel_access_token: String.t(), channel_secret: String.t()}

  defstruct channel_access_token: "", channel_secret: ""

  def send_reply(client, data, reply_token) when is_map(data),
    do: send_reply(client, [data], reply_token)

  def send_reply(client, data, reply_token) do
    messages =
      data
      |> Enum.map(fn x -> LineSdk.MessageObject.to_object(x) end)

    post(client, "/bot/message/reply", %{
      "replyToken" => reply_token,
      "messages" => messages
    })
  end

  def get_content(client, message_id) do
    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <-
           get(client, "/bot/message/#{message_id}/content") do
      {:ok, body}
    end
  end

  def get_profile(client, user_id) do
    user_id = URI.encode(user_id)

    with {:ok, %HTTPoison.Response{body: body, status_code: status_code}} <-
           get(client, "/bot/profile/#{user_id}"),
         {:ok, body} <- Jason.decode(body) do
      case status_code do
        200 -> {:ok, body}
        404 -> {:error, body["message"]}
        _ -> {:error, body}
      end
    end
  end

  def get(%Client{channel_access_token: access_token}, url) do
    headers = [
      {"Authorization", "Bearer #{access_token}"}
    ]

    HTTPoison.get(@line_api_url <> url, headers)
  end

  def post(%Client{channel_access_token: access_token}, url, data) do
    headers = [
      {"Authorization", "Bearer #{access_token}"},
      {"Content-Type", "application/json"}
    ]

    with {:ok, data} <- Jason.encode(data) do
      HTTPoison.post(@line_api_url <> url, data, headers)
    end
  end
end
