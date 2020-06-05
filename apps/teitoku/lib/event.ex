defmodule Teitoku.Event do
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

  @spec handle(LineSdk.Model.WebhookEvent.t(), module()) :: any
  def handle(%LineSdk.Model.WebhookEvent{events: events}, converter) do
    converted =
      events
      |> Enum.map(fn event ->
        reply_token = Map.get(event, :reply_token)

        event
        |> converter.convert_event()
        |> process_event(reply_token)
      end)

    {:ok, converted}
  end

  def process_event(event, reply_token) do
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
        %LineSdk.Model.TextMessage{text: "Error: #{err}"}
        |> LineSdk.Client.send_reply(reply_token)

      {:error, err} ->
        # TODO: Implement proper error logging
        IO.inspect(err)

      {:ignore, _} ->
        nil

      {:continue, event} ->
        process_event({:ok, event}, reply_token)
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
