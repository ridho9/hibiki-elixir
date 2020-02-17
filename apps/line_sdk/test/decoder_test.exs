defmodule LineSdkTest.DecoderTest do
  use ExUnit.Case
  doctest LineSdk

  alias LineSdk.Model

  test "parse webhook event" do
    input =
      ~s(
    {
        "events": [
            {
                "type": "message",
                "replyToken": "reply_token",
                "source": {
                    "userId": "user_id",
                    "type": "user"
                },
                "timestamp": 1575891337932,
                "message": {
                    "type": "text",
                    "id": "msg_id",
                    "text": "!call"
                }
            }
        ],
        "destination": "dest"
    }
      )
      |> Jason.decode!()

    expect = %Model.WebhookEvent{
      destination: "dest",
      events: [
        %Model.MessageEvent{
          timestamp: ~U[2019-12-09 11:35:37.932Z],
          message: %Model.TextMessage{id: "msg_id", text: "!call"},
          reply_token: "reply_token",
          source: %Model.SourceUser{user_id: "user_id"}
        }
      ]
    }

    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse image message external" do
    input =
      ~s(
        {
          "id": "id",
          "type": "image",
          "contentProvider": {
            "type": "external",
            "originalContentUrl": "orig",
            "previewImageUrl": "prev"
          }
        }
      )
      |> Jason.decode!()

    expect = %Model.ImageMessage{
      id: "id",
      provider: "external",
      original_url: "orig",
      preview_url: "prev"
    }

    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse image message line" do
    input =
      ~s(
        {
          "id": "id",
          "type": "image",
          "contentProvider": {
            "type": "line"
          }
        }
      )
      |> Jason.decode!()

    expect = %Model.ImageMessage{id: "id", provider: "line"}
    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse source group" do
    input =
      ~s(
        {
          "type": "group",
          "groupId": "group_id",
          "userId": "user_id"
        }
      )
      |> Jason.decode!()

    expect = %Model.SourceGroup{group_id: "group_id", user_id: "user_id"}
    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse source group no user" do
    input =
      ~s(
        {
          "type": "group",
          "groupId": "group_id"
        }
      )
      |> Jason.decode!()

    expect = %Model.SourceGroup{group_id: "group_id"}
    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse source user" do
    input =
      ~s(
        {
          "type": "user",
          "userId": "user_id"
        }
      )
      |> Jason.decode!()

    expect = %Model.SourceUser{user_id: "user_id"}
    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse source room" do
    input =
      ~s(
        {
          "type": "room",
          "roomId": "room_id",
          "userId": "user_id"
        }
      )
      |> Jason.decode!()

    expect = %Model.SourceRoom{room_id: "room_id", user_id: "user_id"}
    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse source room no user" do
    input =
      ~s(
        {
          "type": "room",
          "roomId": "room_id"
        }
      )
      |> Jason.decode!()

    expect = %Model.SourceRoom{room_id: "room_id"}
    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse message event" do
    input =
      ~s(
{
    "type": "message",
    "replyToken": "reply_token",
    "source": {
        "userId": "user_id",
        "type": "user"
    },
    "timestamp": 1575891337932,
    "message": {
        "type": "text",
        "id": "msg_id",
        "text": "!call"
    }
}
      )
      |> Jason.decode!()

    expect = %Model.MessageEvent{
      timestamp: ~U[2019-12-09 11:35:37.932Z],
      message: %Model.TextMessage{id: "msg_id", text: "!call"},
      reply_token: "reply_token",
      source: %Model.SourceUser{user_id: "user_id"}
    }

    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse text message" do
    input =
      ~s(
        {
          "id": "id",
          "type": "text",
          "text": "hello"
        }
      )
      |> Jason.decode!()

    expect = %Model.TextMessage{text: "hello", id: "id"}
    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse list" do
    input =
      ~s(
        [{
          "id": "id",
          "type": "text",
          "text": "hello"
        },{
          "id": "id",
          "type": "text",
          "text": "hello"
        }]
      )
      |> Jason.decode!()

    expect = [
      %Model.TextMessage{text: "hello", id: "id"},
      %Model.TextMessage{text: "hello", id: "id"}
    ]

    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end
end
