defmodule Teitoku.ValidationText do
  use ExUnit.Case
  doctest Teitoku.Validation
  @secret "secret"

  test "validate success" do
    body = "qwer"
    signature = "uHVaInoJKUNRtT2I5yjlh0590mEZ+98eNBhQGXZcjrw="

    expect = {:ok, nil}
    assert Teitoku.Validation.validate_message(body, @secret, signature) == expect
  end

  test "validate fail" do
    body = "qwer"
    signature = "uHVaInoJKUNRtT2I5yjlh0590mEZ+98eNBhQGXZcj"

    expect = {:error, "invalid signature"}
    assert Teitoku.Validation.validate_message(body, @secret, signature) == expect
  end
end
