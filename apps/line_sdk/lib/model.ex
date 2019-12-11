defmodule LineSdk.Model do
  alias LineSdk.Model

  @type message_object :: Model.TextMessage.t()

  defmodule Source do
    @type t :: Model.SourceUser.t()
  end
end
