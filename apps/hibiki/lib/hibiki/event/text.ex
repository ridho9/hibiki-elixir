defmodule Hibiki.Event.Text do
  @type t :: %__MODULE__{text: String.t()}
  defstruct text: ""
end

defimpl Teitoku.HandleableEvent, for: Hibiki.Event.Text do
  def handle(%Hibiki.Event.Text{text: text}, _ctx) do
    text = String.trim(text)

    # check for tag shortcut
    text =
      Regex.run(~r/#([^\n#]+)#/, text)
      |> case do
        [_, tag] ->
          if String.ends_with?(tag, " ") do
            text
          else
            "!tag - #{tag}"
          end

        _ ->
          text
      end

    cond do
      String.starts_with?(text, "!") and not String.starts_with?(text, "!!") ->
        {:continue, %Hibiki.Event.Command{text: text}}

      true ->
        {:ignore, nil}
    end
  end
end
