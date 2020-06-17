defmodule Teitoku.Command do
  @callback name() :: String.t()
  @callback options() :: Teitoku.Command.Options.t()
  @callback description() :: String.t()
  @callback private() :: boolean()

  @callback handle(Teitoku.Command.Options.t(), any) :: Teitoku.Event.result()

  def handle(command, args, ctx) do
    command.handle(args, ctx)
  end

  defmacro __using__(_opts) do
    quote do
      @behaviour Teitoku.Command

      def options, do: %Teitoku.Command.Options{}
      def description, do: "-- no desc --"
      def private, do: false

      defoverridable(Teitoku.Command)
    end
  end
end
