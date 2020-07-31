defmodule Hibiki.Upload.Provider.Tenshi do
  require Logger
  use Hibiki.Upload.Provider

  use Tesla
  alias Tesla.Multipart
  plug(Tesla.Middleware.BaseUrl, "https://file.tenshi.dev")

  import Hibiki.Upload.Provider.Catbox, only: [mime_file: 1]

  def id, do: :tenshi

  def upload_binary(binary) do
    with {:ok, path} <- Temp.path(),
         :ok <- File.write(path, binary),
         {:ok, mime} <- mime_file(path),
         ext = mime |> :mimerl.mime_to_exts() |> hd do
      Logger.info("mime #{mime} ext #{ext}")

      filename = Path.basename(path) <> ".#{ext}"

      body =
        Multipart.new()
        |> Multipart.add_file(path, name: "file", filename: filename, detect_content_type: true)

      result = post("/upload", body)
      File.rm(path)

      with {:ok, %Tesla.Env{body: body}} <- result,
           {:ok, body} <- Jason.decode(body),
           %{"code" => code, "message" => message} = body do
        case code do
          200 -> {:ok, "https://file.tenshi.dev/download?file=#{message}"}
          _ -> {:error, message}
        end
      end
    end
  end
end
