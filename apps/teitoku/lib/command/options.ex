defmodule Teitoku.Command.Options do
  alias Teitoku.Command.Options

  @type t :: %__MODULE__{
          named: list(),
          flag: list(),
          allow_empty: boolean(),
          desc: map()
        }
  defstruct named: [], flag: [], allow_empty: false, desc: %{}

  @spec add_named(Options.t(), String.t(), keyword()) :: Options.t()
  def add_named(%__MODULE__{named: named} = options, name, opt \\ []) do
    %{options | named: named ++ [name]}
    |> add_desc(name, opt)
  end

  @spec add_flag(Options.t(), String.t(), keyword()) :: Options.t()
  def add_flag(%__MODULE__{flag: flag} = options, name, opt \\ []) do
    %{options | flag: flag ++ [name]}
    |> add_desc(name, opt)
  end

  @spec allow_empty(Options.t()) :: Options.t()
  def allow_empty(options) do
    %{options | allow_empty: true}
  end

  defp add_desc(%__MODULE__{desc: desc} = options, name, opt) do
    if opt[:desc] != nil do
      %{options | desc: Map.put(desc, name, opt[:desc])}
    else
      options
    end
  end
end
