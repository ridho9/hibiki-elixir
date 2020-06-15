defmodule Hibiki.Command.Code do
  use Teitoku.Command
  alias Teitoku.Command.Options

  def name, do: "code"

  def description, do: "THE NUMBERS WHAT IT MEANS"

  def private, do: true

  def options,
    do:
      %Options{}
      |> Options.add_named("code", desc: "Code to search")
      |> Options.add_flag("o", desc: "Add open button")

  def handle(%{"code" => code} = args, _ctx) do
    code = URI.encode_www_form(code)

    url =
      "https://opener.now.sh/api/data/#{code}"
      |> String.trim()
      |> URI.encode()

    with {:ok, %HTTPoison.Response{body: body}} <- HTTPoison.get(url, follow_redirect: true),
         {:ok, result} <- Jason.decode(body) do
      handle_result(args, result)
    end
  end

  defp handle_result(%{"code" => code, "o" => open}, %{"success" => true} = result) do
    %{"title" => title, "tags" => tags} = result
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

  defp handle_result(_, %{"success" => false} = result) do
    {:reply_error, result["description"]}
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