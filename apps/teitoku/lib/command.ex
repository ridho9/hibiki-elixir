defmodule Teitoku.Command do
  @callback name() :: String.t()
  @callback options() :: Teitoku.Command.Options.t()

  @callback handle(Teitoku.Command.Options.t(), any) :: Teitoku.Event.result()

  defmacro __using__(_opts) do
    quote do
      @behaviour Teitoku.Command

      def options, do: %Teitoku.Command.Options{}

      defoverridable(Teitoku.Command)
    end
  end
end
