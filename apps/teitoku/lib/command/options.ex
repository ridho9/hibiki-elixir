defmodule Teitoku.Command.Options do
  alias Teitoku.Command.Options

  @type t :: %__MODULE__{named: list()}
  defstruct named: []

  @spec add_named(Options.t(), String.t()) :: Options.t()
  def add_named(%__MODULE__{named: named} = options, name) do
    named = named ++ [name]

    %{options | named: named}
  end
end
