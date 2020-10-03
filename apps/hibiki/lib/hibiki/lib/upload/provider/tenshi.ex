defmodule Hibiki.Upload.Provider.Tenshi do
  require Logger
  use Hibiki.Upload.Provider

  import Hibiki.Upload.Provider.Catbox, only: [mime_file: 1]

  def id, do: :tenshi

  def upload_binary(binary) do
    with {:ok, path} <- Temp.path(),
         :ok <- File.write(path, binary),
         {:ok, mime} <- mime_file(path) do
      ext = mime |> :mimerl.mime_to_exts() |> hd
      Logger.info("mime #{mime} ext #{ext}")

      file =
        {:file, path, {"form-data", [name: "file", filename: Path.basename(path) <> ".#{ext}"]},
         []}

      data = {:multipart, [file]}
      url = "https://file.tenshi.dev/upload"
      Logger.info("data #{inspect(data)}")

      result =
        HTTPoison.post(url, data, [],
          hackney: [pool: :tenshi],
          recv_timeout: 60_000,
          timeout: 60_000
        )

      File.rm(path)

      # with {:ok, %HTTPoison.Response{body: body}} <- result,
      res =
        with {:ok, %HTTPoison.Response{body: body}} <- result,
             {:ok, body} <- Jason.decode(body) do
          Logger.info(inspect(body))
          %{"code" => code, "message" => message} = body

          case code do
            200 -> {:ok, "https://file.tenshi.dev/download?file=#{message}"}
            _ -> {:error, message}
          end
        end

      Logger.info("result #{inspect(res)}")

      res
    end
  end
end
