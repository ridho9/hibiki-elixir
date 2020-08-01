defmodule Hibiki.Upload.Provider.Catbox do
  use Hibiki.Upload.Provider

  use Tesla
  alias Tesla.Multipart
  plug(Tesla.Middleware.BaseUrl, "https://catbox.moe/user/api.php")
  plug(Tesla.Middleware.Timeout, timeout: 20_000)

  def id, do: :catbox

  def upload_binary(binary) do
    with {:ok, path} <- Temp.path(),
         :ok <- File.write(path, binary),
         {:ok, mime} <- mime_file(path),
         ext = mime |> :mimerl.mime_to_exts() |> hd do
      filename = Path.basename(path) <> ".#{ext}"

      body =
        Multipart.new()
        |> Multipart.add_file(path,
          name: "fileToUpload",
          filename: filename,
          detect_content_type: true
        )
        |> Multipart.add_field("reqtype", "fileupload")
        |> Multipart.add_field("userhash", "")

      result = post("", body)
      File.rm(path)

      with {:ok, %Tesla.Env{body: link}} <- result do
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
