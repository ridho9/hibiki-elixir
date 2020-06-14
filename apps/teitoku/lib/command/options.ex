defmodule Teitoku.Command.Options do
  alias Teitoku.Command.Options

  @type t :: %__MODULE__{
          named: list(),
          flag: list(),
          allow_empty: boolean()
        }
  defstruct named: [], flag: [], allow_empty: false

  @spec add_named(Options.t(), String.t()) :: Options.t()
  def add_named(%__MODULE__{named: named} = options, name) do
    named = named ++ [name]

    %{options | named: named}
  end

  @spec add_flag(Options.t(), String.t()) :: Options.t()
  def add_flag(%__MODULE__{flag: flag} = options, name) do
    %{options | flag: flag ++ [name]}
  end

  @spec allow_empty(Options.t()) :: Options.t()
  def allow_empty(options) do
    %{options | allow_empty: true}
  end
end
