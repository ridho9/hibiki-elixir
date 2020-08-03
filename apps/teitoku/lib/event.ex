defmodule Teitoku.Event do
  require Logger

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
          | {:continue, any}

  @spec handle(LineSdk.Model.WebhookEvent.t(), LineSdk.Client.t(), module()) :: any
  def handle(%LineSdk.Model.WebhookEvent{events: events}, client, converter) do
    converted =
      events
      |> Enum.map(fn event ->
        reply_token = Map.get(event, :reply_token) || Map.get(event, "replyToken")

        event
        |> converter.convert(%{start_time: DateTime.utc_now()})
        |> process_event(client, reply_token)
      end)

    {:ok, converted}
  end

  def process_event({:error, err}, _, _) do
    {:ignore, err}
  end

  def process_event({:ok, event, ctx}, client, reply_token) do
    Logger.metadata(reply_token: reply_token)

    Teitoku.HandleableEvent.handle(event, ctx)
    |> case do
      {:reply, message} ->
        LineSdk.Client.send_reply(client, message, reply_token)

      {:reply_error, err} ->
        msg = %LineSdk.Model.TextMessage{text: "Error: #{err}"}
        LineSdk.Client.send_reply(client, msg, reply_token)

      {:error, err} ->
        # TODO: Implement proper error logging
        Logger.error(inspect(err))
        nil

      {:ignore, _} ->
        nil

      {:continue, event} ->
        process_event({:ok, event, ctx}, client, reply_token)
    end
  end
end

defprotocol Teitoku.HandleableEvent do
  @spec handle(any, map) :: Teitoku.Event.result()
  def handle(event, ctx)

  @fallback_to_any true
end

defimpl Teitoku.HandleableEvent, for: Any do
  def handle(event, _ctx) do
    {:ignore, "can't handle event #{inspect(event)}"}
  end
end
