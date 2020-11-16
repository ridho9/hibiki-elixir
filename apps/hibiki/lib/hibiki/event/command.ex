defmodule Hibiki.Event.Command do
  @type t :: %__MODULE__{text: String.t()}
  defstruct text: ""
end

defimpl Teitoku.HandleableEvent, for: Hibiki.Event.Command do
  require Logger

  def handle(%Hibiki.Event.Command{text: text}, %{start_time: start_time} = ctx) do
    # start parsing and defining command here
    text
    |> String.slice(1..-1)
    |> String.trim_leading()
    |> Teitoku.Command.Registry.prepare(Hibiki.Registry)
    |> case do
      {:ok, command, args} ->
        Logger.metadata(command: command, command_args: args, command_ctx: ctx)
        Logger.info("start handle command")

        res = Teitoku.Command.handle(command, args, ctx)

        # duration = System.system_time(:millisecond) - start_time
        duration = System.monotonic_time() - start_time
        duration = System.convert_time_unit(duration, :native, :microsecond)

        Logger.info("end handle command in #{duration / 1000}ms")

        :telemetry.execute([:hibiki, :command, :finish], %{duration: duration}, %{
          command: command
        })

        res

      {:error, msg} ->
        {:reply_error, msg}
    end
  end
end
