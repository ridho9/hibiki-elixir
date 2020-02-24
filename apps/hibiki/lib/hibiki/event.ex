defmodule Hibiki.Event do
  @typedoc """
  - `{:ok, any}` don't do anything
  - `{:reply, message}` to reply with a successful message.
  - `{:reply_error, message}` to reply with fail message, won't be logged.
  - `{:error, err}` when error, will be logged.
  - `{:error_ignore, err}` when error, will not be logged
  """
  @type result ::
          {:ok, any} | {:reply, any} | {:reply_error, String.t()} | {:error, String.t()}

  @spec webhook_handle(LineSdk.Model.WebhookEvent.t()) :: any
  def webhook_handle(%LineSdk.Model.WebhookEvent{events: events}) do
    converted =
      events
      |> Enum.map(&Hibiki.Event.process_event/1)

    {:ok, converted}
  end

  @spec process_event(LineSdk.Model.message_object()) :: any
  def process_event(event) do
    reply_token = Map.get(event, :reply_token)

    event
    |> handle_event()
    |> IO.inspect()
    |> case do
      {:reply, message} ->
        LineSdk.Client.send_reply(message, reply_token)

      {:reply_error, err} ->
        %LineSdk.Model.TextMessage{text: "Error happened: #{err}"}
        |> LineSdk.Client.send_reply(reply_token)

      {:error, err} ->
        IO.inspect(err)

      {:error_ignore, err} ->
        err
    end
  end

  @spec handle_event(LineSdk.Model.message_object()) :: result()

  def handle_event(%LineSdk.Model.MessageEvent{message: %LineSdk.Model.TextMessage{text: text}}) do
    {:reply, %LineSdk.Model.TextMessage{text: "ahahaha #{text}"}}
  end

  def handle_event(event) do
    {:error_ignore, "cant handle event #{inspect(event)}"}
  end
end
