defmodule Hibiki.Event.Command do
  @type t :: %__MODULE__{text: String.t()}
  defstruct text: ""
end

defimpl Teitoku.HandleableEvent, for: Hibiki.Event.Command do
  def handle(%Hibiki.Event.Command{text: text}, ctx) do
    # start parsing and defining command here
    text
    |> String.slice(1..-1)
    |> String.trim_leading()
    |> Teitoku.Command.Registry.prepare(Hibiki.Registry)
    |> case do
      {:ok, command, args} ->
        Logger.metadata(command: command, command_args: args, command_ctx: ctx)
        Teitoku.Command.handle(command, args, ctx)

      {:error, msg} ->
        {:reply_error, msg}
    end
  end
end
