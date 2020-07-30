defmodule Hibiki.Command.Upload do
  use Teitoku.Command
  alias Hibiki.Entity
  alias Hibiki.Upload
  alias LineSdk.Model

  require Logger

  def name, do: "upload"

  def description, do: "Upload last sent image from this scope to catbox"

  def handle(_args, %{source: source}) do
    source
    |> Entity.Data.get(Entity.Data.Key.last_image_id())
    |> case do
      nil ->
        {:reply_error, "Please send an image first"}

      image_id ->
        Logger.info("image id #{image_id}")

        case Upload.upload_from_image_id(Upload.Provider.Tenshi, image_id) do
          {:error, err} ->
            {:reply_error, err}

          {:ok, url} ->
            {:reply, %Model.TextMessage{text: url}}
        end
    end
  end
end
