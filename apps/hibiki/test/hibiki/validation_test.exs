defmodule Hibiki.ValidationText do
  use ExUnit.Case
  doctest Hibiki.Validation

  test "validate success" do
    body = "qwer"
    signature = "uHVaInoJKUNRtT2I5yjlh0590mEZ+98eNBhQGXZcjrw="

    expect = {:ok, nil}
    assert Hibiki.Validation.validate_message(body, signature) == expect
  end

  test "validate fail" do
    body = "qwer"
    signature = "uHVaInoJKUNRtT2I5yjlh0590mEZ+98eNBhQGXZcj"

    expect = {:error, "invalid signature"}
    assert Hibiki.Validation.validate_message(body, signature) == expect
  end
end
