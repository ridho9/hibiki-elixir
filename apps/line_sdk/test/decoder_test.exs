defmodule LineSdkTest.DecoderTest do
  use ExUnit.Case
  doctest LineSdk

  alias LineSdk.Model

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
      id: "msg_id",
      message: %Model.TextMessage{text: "!call"},
      reply_token: "reply_token",
      source: %Model.SourceUser{user_id: "user_id"}
    }

    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end

  test "parse text message" do
    input =
      ~s(
        {
          "type": "text",
          "text": "hello"
        }
      )
      |> Jason.decode!()

    expect = %Model.TextMessage{text: "hello"}
    assert LineSdk.Decoder.decode(input) == {:ok, expect}
  end
end
