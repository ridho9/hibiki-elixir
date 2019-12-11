defmodule LineSdk.Decoder do
  alias LineSdk.Model

  def decode(body, opts \\ [])

  def decode(
        %{
          "type" => "message",
          "message" => message,
          "timestamp" => timestamp,
          "replyToken" => reply_token,
          "source" => source
        },
        opts
      ) do
    with %{"id" => id} = message,
         {:ok, message} <- decode(message, opts),
         {:ok, timestamp} <- DateTime.from_unix(timestamp, :millisecond),
         {:ok, source} <- decode(source, opts) do
      {:ok,
       %Model.MessageEvent{
         id: id,
         message: message,
         timestamp: timestamp,
         reply_token: reply_token,
         source: source
       }}
    end
  end

  def decode(%{"type" => "text", "text" => text}, _opts) do
    {:ok, %Model.TextMessage{text: text}}
  end

  def decode(%{"type" => "user", "userId" => user_id}, _opts) do
    {:ok, %Model.SourceUser{user_id: user_id}}
  end

  def decode(body, _opts) do
    {:ok, body}
  end
end
