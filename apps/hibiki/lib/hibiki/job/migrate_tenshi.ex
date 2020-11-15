defmodule Hibiki.Job.MigrateTenshi do
  require Logger

  def run_file(filename) do
    content =
      File.read!(filename)
      |> String.trim()
      |> String.split("\n")
      |> Enum.map(fn line ->
        String.split(line, ",")
      end)

    for [id, value] <- content do
      case update_tag(id, value) do
        {:ok, _} ->
          Logger.info("#{id} OK")

        {:error, err} ->
          err = Hibiki.Tag.format_error(err)
          Logger.error("#{id} ERROR #{err}")
      end
    end
  end

  def update_tag(id, new_value) do
    tag = Hibiki.Tag.by_id(id)
    cs = %{value: new_value}
    Hibiki.Tag.update(tag, cs)
  end
end
