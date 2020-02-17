defmodule LineSdk.AuthTest do
  use ExUnit.Case
  doctest LineSdk.Auth

  test "calculate signature" do
    message = "qwer"
    channel_secret = "secret"

    expect = "uHVaInoJKUNRtT2I5yjlh0590mEZ+98eNBhQGXZcjrw="

    assert LineSdk.Auth.calculate_signature(message, channel_secret) == expect
  end

  test "signature match" do
    message = "qwer"
    channel_secret = "secret"
    expect = "uHVaInoJKUNRtT2I5yjlh0590mEZ+98eNBhQGXZcjrw="

    assert LineSdk.Auth.signature_match?(message, channel_secret, expect)
  end
end
