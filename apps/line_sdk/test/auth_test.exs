defmodule LineSdk.AuthTest do
  use ExUnit.Case
  doctest LineSdk.Auth
  @secret "secret"

  test "calculate signature" do
    message = "qwer"
    expect = "uHVaInoJKUNRtT2I5yjlh0590mEZ+98eNBhQGXZcjrw="

    assert LineSdk.Auth.calculate_signature(message, @secret) == expect
  end

  test "signature match" do
    message = "qwer"
    expect = "uHVaInoJKUNRtT2I5yjlh0590mEZ+98eNBhQGXZcjrw="

    assert LineSdk.Auth.signature_match?(message, @secret, expect)
  end
end
