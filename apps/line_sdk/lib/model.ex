defmodule LineSdk.Model do
  alias LineSdk.Model

  @type message_object :: Model.TextMessage.t() | Model.ImageMessage.t()

  defmodule Source do
    @type t :: Model.SourceUser.t() | Model.SourceGroup.t() | Model.SourceRoom.t()
  end
end
