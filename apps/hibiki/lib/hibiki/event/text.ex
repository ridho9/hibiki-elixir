defmodule Hibiki.Event.Text do
  @type t :: %__MODULE__{text: String.t()}
  defstruct text: ""
end

defimpl Teitoku.HandleableEvent, for: Hibiki.Event.Text do
  def handle(%Hibiki.Event.Text{text: text}) do
    text = String.trim(text)

    cond do
      String.starts_with?(text, "!") and not String.starts_with?(text, "!!") ->
        {:continue, %Hibiki.Event.Command{text: text}}

      true ->
        {:ignore, nil}
    end
  end
end
