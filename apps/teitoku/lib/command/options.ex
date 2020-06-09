defmodule Teitoku.Command.Options do
  alias Teitoku.Command.Options

  @type t :: %__MODULE__{named: list(), flag: list()}
  defstruct named: [], flag: []

  @spec add_named(Options.t(), String.t()) :: Options.t()
  def add_named(%__MODULE__{named: named} = options, name) do
    named = named ++ [name]

    %{options | named: named}
  end

  @spec add_flag(Options.t(), String.t()) :: Options.t()
  def add_flag(%__MODULE__{flag: flag} = options, name) do
    %{options | flag: flag ++ [name]}
  end
end
