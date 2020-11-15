defmodule Hibiki.Command.Upload do
  use Teitoku.Command
  alias Teitoku.Command.Arguments
  alias Hibiki.Entity
  alias Hibiki.Upload
  alias LineSdk.Model

  require Logger

  def name, do: "upload"

  def description, do: "Upload last sent image from this scope to catbox"

  def options,
    do:
      %Arguments{}
      |> Arguments.allow_empty()
      |> Arguments.add_named("url", desc: "image url, use this to reupload from a url")

  def handle(%{"url" => ""}, %{source: source}) do
    source
    |> Entity.Data.get(Entity.Data.Key.last_image_id())
    |> case do
      nil ->
        {:reply_error, "Please send an image first"}

      image_id ->
        Logger.info("image id #{image_id}")

        case Upload.upload_from_image_id(Upload.Provider.Kryk, image_id) do
          {:error, err} ->
            {:reply_error, err}

          {:ok, url} ->
            {:reply, %Model.TextMessage{text: url}}
        end
    end
  end

  def handle(%{"url" => url}, _ctx) do
    Upload.from_url(Upload.Provider.Kryk, url)
    |> case do
      {:error, err} ->
        {:reply_error, err}

      {:ok, url} ->
        {:reply, %Model.TextMessage{text: url}}
    end
  end
end
