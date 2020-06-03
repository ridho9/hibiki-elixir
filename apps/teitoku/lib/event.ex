defmodule Teitoku.Event do
  @converter Application.get_env(:teitoku, :converter)

  @typedoc """
  - `{:ok, any}` don't do anything
  - `{:reply, message}` to reply with a successful message.
  - `{:reply_error, message}` to reply with fail message, won't be logged.
  - `{:error, err}` when error, will be logged.
  - `{:ignore, any}` to ignore result
  - `{:continue, t()}` to continue handling (for when an event created another event)
  """
  @type result ::
          {:ok, any}
          | {:reply, any}
          | {:reply_error, String.t()}
          | {:error, String.t()}
          | {:ignore, any}

  @spec webhook_handle(LineSdk.Model.WebhookEvent.t()) :: any
  def webhook_handle(%LineSdk.Model.WebhookEvent{events: events}) do
    converted =
      events
      |> Enum.map(&Teitoku.Event.process_event/1)

    {:ok, converted}
  end

  @spec process_event(LineSdk.Model.message_object()) :: any
  def process_event(event) do
    reply_token = Map.get(event, :reply_token)

    event
    |> @converter.convert_event()
    |> process_single_event(reply_token)
  end

  def process_single_event(event, reply_token) do
    event
    |> case do
      {:ok, event} -> Teitoku.HandleableEvent.handle(event)
      {:error, error} -> {:ignore, error}
    end
    |> IO.inspect()
    |> case do
      {:reply, message} ->
        LineSdk.Client.send_reply(message, reply_token)

      {:reply_error, err} ->
        %LineSdk.Model.TextMessage{text: "Error happened: #{err}"}
        |> LineSdk.Client.send_reply(reply_token)

      {:error, err} ->
        # TODO: Implement proper error logging
        IO.inspect(err)

      {:ignore, _} ->
        nil

      {:continue, event} ->
        process_single_event({:ok, event}, reply_token)
    end
  end
end

defprotocol Teitoku.HandleableEvent do
  @spec handle(any) :: Teitoku.Event.result()
  @fallback_to_any true
  def handle(event)
end

defimpl Teitoku.HandleableEvent, for: Any do
  def handle(event) do
    {:ignore, "can't handle event #{inspect(event)}"}
  end
end
