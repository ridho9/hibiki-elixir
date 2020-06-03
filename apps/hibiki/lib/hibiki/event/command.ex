defmodule Hibiki.Event.Command do
  @type t :: %__MODULE__{text: String.t()}
  defstruct text: ""
end

defimpl Teitoku.HandleableEvent, for: Hibiki.Event.Command do
  def handle(%Hibiki.Event.Command{text: text}) do
    # start parsing and defining command here
    text
    |> String.slice(1..-1)
    |> String.trim_leading()
    |> Teitoku.Command.Registry.resolve_text()
    |> case do
      {:ok, command, args} -> command.handle(args)
      {:error, msg} -> {:reply_error, msg}
    end
  end
end
