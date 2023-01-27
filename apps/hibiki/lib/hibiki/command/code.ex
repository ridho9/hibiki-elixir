defmodule Hibiki.Command.Code do
  use Teitoku.Command
  alias Teitoku.Command.Arguments

  @base_url "https://nhentai.net/api"

  def name, do: "code"

  def description, do: "THE NUMBERS WHAT IT MEANS"

  def private, do: true

  def options,
    do:
      %Arguments{}
      |> Arguments.add_named("code", desc: "Code to search")
      |> Arguments.add_flag("o", desc: "Add open button")

  def handle(%{"code" => code} = args, _ctx) do
    fs_url = Application.fetch_env!(:hibiki, :flaresolverr_host) <> "/v1"
    url = @base_url <> "/gallery/#{code}"

    body =
      %{
        "cmd" => "request.get",
        "url" => url,
        "maxTimeout" => 30000,
        "session" => "e5eeafea-9d68-11ed-936f-8b1f617f0cbc"
      }
      |> Jason.encode!()

    headers = [{"Content-Type", "application/json"}]

    with {:ok, %HTTPoison.Response{body: body}} <-
           HTTPoison.post(fs_url, body, headers),
         {:ok, result} <- Jason.decode(body),
         {:ok, result} <- parse_fs_result(result) do
      handle_result(args, result)
    end
  end

  defp parse_fs_result(%{"status" => "ok", "solution" => %{"response" => response}}) do
    case Regex.run(~r/>({.*})</, response) do
      [_, response] ->
        response = Jason.decode!(response)
        {:ok, response}

      _ ->
        {:error, "failed parsing fs body"}
    end
  end

  defp parse_fs_result(_) do
    {:reply_error, "failed fs request"}
  end

  defp handle_result(_, %{"error" => err}) do
    {:reply_error, err}
  end

  defp handle_result(%{"code" => code, "o" => open}, %{"title" => title, "tags" => tags}) do
    title = title["english"] || title["japanese"]

    artists = get_tags_by_type(tags, "artist")
    languages = get_tags_by_type(tags, "language")
    cat_tags = get_tags_by_type(tags, "tag")
    parodies = get_tags_by_type(tags, "parody")

    message =
      [
        "[#{code}]" <> title,
        "Parody: #{parodies}",
        "Tag: #{cat_tags}",
        "Artist: #{artists}",
        "Language: #{languages}"
      ]
      |> Enum.join("\n")

    resp = [
      %LineSdk.Model.TextMessage{text: message}
      | if open do
          [%LineSdk.Model.RawMessage{content: create_button_message(code)}]
        else
          []
        end
    ]

    {:reply, resp}
  end

  defp create_button_message(code) do
    action = %{
      "type" => "uri",
      "label" => "open",
      "uri" => "https://nhentai.net/g/#{code}"
    }

    %{
      "type" => "flex",
      "altText" => "Open",
      "contents" => %{
        "type" => "bubble",
        "body" => %{
          "type" => "box",
          "layout" => "vertical",
          "spacing" => "none",
          "margin" => "none",
          "contents" => [
            %{
              "type" => "button",
              "action" => action
            }
          ]
        }
      }
    }
  end

  defp get_tags_by_type(tags, type) do
    res =
      tags
      |> Enum.filter(fn x -> x["type"] == type end)
      |> Enum.map_join(", ", fn x -> x["name"] end)
      |> String.trim()

    if res == "", do: "-", else: res
  end
end
