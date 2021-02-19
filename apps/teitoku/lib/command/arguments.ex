defmodule Teitoku.Command.Arguments do
  alias Teitoku.Command.Arguments

  @type t :: %__MODULE__{
          named: list(),
          flag: list(),
          allow_empty: boolean(),
          desc: map(),
          hidden: list(),
          name: map(),
          tokenize_last: boolean()
        }
  defstruct named: [],
            flag: [],
            allow_empty: false,
            desc: %{},
            hidden: [],
            name: %{},
            tokenize_last: false

  @spec add_named(Arguments.t(), String.t(), keyword()) :: Arguments.t()
  def add_named(%__MODULE__{named: named} = options, name, opt \\ []) do
    %{options | named: named ++ [name]}
    |> add_desc(name, opt)
  end

  @spec add_flag(Arguments.t(), String.t(), keyword()) :: Arguments.t()
  def add_flag(%__MODULE__{flag: flag} = options, name, opt \\ []) do
    %{options | flag: flag ++ [name]}
    |> add_desc(name, opt)
  end

  @spec allow_empty(Arguments.t()) :: Arguments.t()
  def allow_empty(options) do
    %{options | allow_empty: true}
  end

  @spec tokenize_last(Arguments.t()) :: Arguments.t()
  def tokenize_last(options) do
    %{options | tokenize_last: true}
  end

  defp add_desc(options, name, settings) do
    Enum.reduce(settings, options, fn {key, value}, current ->
      case key do
        :desc ->
          %{current | desc: Map.put(current.desc, name, value)}

        :name ->
          %{current | name: Map.put(current.name, name, value)}

        :hidden ->
          if value do
            %{current | hidden: [name | current.hidden]}
          else
            current
          end
      end
    end)
  end
end
