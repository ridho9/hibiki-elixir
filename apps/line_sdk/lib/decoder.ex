defmodule LineSdk.Decoder do
  alias LineSdk.Model

  def decode(body, opts \\ [])

  def decode(%{"destination" => destination, "events" => events}, opts) do
    with {:ok, events} <- decode(events, opts) do
      {:ok, %Model.WebhookEvent{destination: destination, events: events}}
    end
  end

  def decode(%{"events" => events}, opts) do
    with {:ok, events} <- decode(events, opts) do
      {:ok, %Model.WebhookEvent{events: events}}
    end
  end

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
    with {:ok, message} <- decode(message, opts),
         {:ok, timestamp} <- DateTime.from_unix(timestamp, :millisecond),
         {:ok, source} <- decode(source, opts) do
      {:ok,
       %Model.MessageEvent{
         message: message,
         timestamp: timestamp,
         reply_token: reply_token,
         source: source
       }}
    end
  end

  def decode(
        %{
          "type" => "image",
          "id" => id,
          "contentProvider" => %{
            "type" => "external",
            "originalContentUrl" => orig,
            "previewImageUrl" => prev
          }
        },
        _opts
      ) do
    {:ok,
     %Model.ImageMessage{id: id, provider: "external", original_url: orig, preview_url: prev}}
  end

  def decode(%{"type" => "image", "id" => id, "contentProvider" => %{"type" => "line"}}, _opts) do
    {:ok, %Model.ImageMessage{id: id, provider: "line"}}
  end

  def decode(%{"type" => "text", "text" => text, "id" => id}, _opts) do
    {:ok, %Model.TextMessage{text: text, id: id}}
  end

  def decode(%{"type" => "user", "userId" => user_id}, _opts) do
    {:ok, %Model.SourceUser{user_id: user_id}}
  end

  def decode(%{"type" => "group", "userId" => user_id, "groupId" => group_id}, _opts) do
    {:ok, %Model.SourceGroup{group_id: group_id, user_id: user_id}}
  end

  def decode(%{"type" => "group", "groupId" => group_id}, _opts) do
    {:ok, %Model.SourceGroup{group_id: group_id}}
  end

  def decode(%{"type" => "room", "userId" => user_id, "roomId" => room_id}, _opts) do
    {:ok, %Model.SourceRoom{room_id: room_id, user_id: user_id}}
  end

  def decode(%{"type" => "room", "roomId" => room_id}, _opts) do
    {:ok, %Model.SourceRoom{room_id: room_id}}
  end

  def decode([], _), do: {:ok, []}

  def decode([item], opts) do
    with {:ok, item} <- decode(item, opts) do
      {:ok, [item]}
    end
  end

  def decode([head | rest], opts) do
    with {:ok, rest} <- decode(rest, opts),
         {:ok, head} <- decode(head, opts) do
      {:ok, [head | rest]}
    end
  end

  def decode(body, _opts) do
    {:eror, "Unable to decode #{inspect(body)}"}
  end
end
