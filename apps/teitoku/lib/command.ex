defmodule Teitoku.Command do
  @callback name() :: String.t()
  @callback options() :: Teitoku.Command.Arguments.t()
  @callback description() :: String.t()
  @callback private() :: boolean()
  @callback subcommands() :: list(module())

  @callback prehandle() :: list(function())
  @callback handle(Teitoku.Command.Arguments.t(), any) :: Teitoku.Event.result()

  require Logger

  def handle(command, args, ctx) do
    case process_prehandle(command.prehandle, args, ctx) do
      {:ok, args, ctx} ->
        command.handle(args, ctx)

      {:error, msg} ->
        {:reply_error, msg}
    end
  end

  def process_prehandle(prehandle, args, ctx)

  def process_prehandle([], args, ctx), do: {:ok, args, ctx}

  def process_prehandle([f | rest], args, ctx) do
    with {:ok, args, ctx} <- apply(f, [args, ctx]) do
      process_prehandle(rest, args, ctx)
    end
  end

  def command?(module) do
    attributes = module.__info__(:attributes)
    behaviour = Keyword.get(attributes, :behaviour, [])
    Teitoku.Command in behaviour
  end

  defmacro __using__(_opts) do
    quote do
      @behaviour Teitoku.Command

      def options, do: %Teitoku.Command.Arguments{}
      def description, do: "-- no desc --"
      def private, do: false
      def subcommands, do: []
      def prehandle, do: []

      defoverridable(Teitoku.Command)

      @on_load :on_load
      def on_load do
        :ok
      end
    end
  end
end
