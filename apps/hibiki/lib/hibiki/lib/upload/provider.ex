defmodule Hibiki.Upload.Provider do
  @callback upload_binary(binary) :: {:ok, String.t()} | {:error, any}
  @callback id :: atom

  defmacro __using__(_opts) do
    quote do
      @behaviour Hibiki.Upload.Provider
    end
  end
end

defmodule Hibiki.Upload.Provider.Catbox do
  use Hibiki.Upload.Provider

  def id, do: :catbox

  def upload_binary(binary) do
    with {:ok, path} <- Temp.path(),
         :ok <- File.write(path, binary),
         {:ok, mime} <- mime_file(path),
         ext = mime |> :mimerl.mime_to_exts() |> hd do
      file =
        {:file, path,
         {"form-data", [name: "fileToUpload", filename: Path.basename(path) <> ".#{ext}"]}, []}

      data = {:multipart, [file, {"reqtype", "fileupload"}, {"userhash", ""}]}
      url = "https://catbox.moe/user/api.php"

      result = HTTPoison.post(url, data)
      File.rm(path)

      with {:ok, %HTTPoison.Response{body: link}} <- result do
        {:ok, link}
      end
    end
  end

  def mime_file(path) do
    with {filetype, 0} <- System.cmd("file", [path, "--mime-type"]),
         mime = String.slice(filetype, (String.length(path) + 2)..-2) do
      {:ok, mime}
    end
  end
end

defmodule Hibiki.Upload.Provider.Tenshi do
  use Hibiki.Upload.Provider
  require Logger

  import Hibiki.Upload.Provider.Catbox, only: [mime_file: 1]

  def id, do: :tenshi

  def upload_binary(binary) do
    with {:ok, path} <- Temp.path(),
         :ok <- File.write(path, binary),
         {:ok, mime} <- mime_file(path),
         ext = mime |> :mimerl.mime_to_exts() |> hd do
      Logger.info("mime #{mime} ext #{ext}")

      file =
        {:file, path, {"form-data", [name: "file", filename: Path.basename(path) <> ".#{ext}"]},
         []}

      data = {:multipart, [file]}
      url = "https://file.tenshi.dev/upload"
      Logger.info("uploading to #{url} #{data}")

      result = HTTPoison.post(url, data)
      File.rm(path)

      Logger.info("result #{result}")

      with {:ok, %HTTPoison.Response{body: body}} <- result,
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
