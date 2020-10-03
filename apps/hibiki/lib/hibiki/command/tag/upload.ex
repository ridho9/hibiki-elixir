defmodule Hibiki.Command.Tag.Upload do
  require Logger
  use Teitoku.Command
  alias Teitoku.Command.Options
  alias Hibiki.Tag
  alias Hibiki.Entity
  alias Hibiki.Upload

  def name, do: "upload"

  def description, do: ""

  def options,
    do:
      %Options{}
      |> Options.add_named("name", desc: "tag name")
      |> Options.add_flag("!", hidden: true, name: "global?")

  def prehandle,
    do: [
      &Hibiki.Command.Tag.Create.load_global/2,
      &Hibiki.Command.Tag.Create.check_added/2
    ]

  def handle(
        %{"name" => name},
        %{source: source} = opt
      ) do
    case Tag.by_name(name, source) do
      nil ->
        # upload last sent image
        source
        |> Entity.Data.get(Entity.Data.Key.last_image_id())
        |> case do
          nil ->
            {:reply_error, "Please send an image first"}

          image_id ->
            upload_image(image_id, name, opt)
        end

      _ ->
        {:reply_error, "Error creating tag '#{name}': name has already been taken"}
    end
  end

  def upload_image(image_id, name, %{
        source: %Entity{type: source_type} = source,
        user: user
      }) do
    Logger.info("image id #{image_id}")

    case Upload.upload_from_image_id(Upload.Provider.Tenshi, image_id) do
      {:error, err} ->
        {:reply_error, err}

      {:ok, url} ->
        name = String.trim(name) |> String.downcase()

        case Tag.create(name, "image", url, user, source) do
          {:ok, %{name: tag_name}} ->
            {:reply,
             %LineSdk.Model.TextMessage{
               text:
                 "Successfully created tag '#{tag_name}' in this #{source_type} with value #{url}"
             }}

          {:error, err} ->
            {:reply_error, "Error creating tag '#{name}': " <> Tag.format_error(err)}
        end
    end
  end
end
