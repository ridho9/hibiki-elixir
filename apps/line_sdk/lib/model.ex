defmodule LineSdk.Model do
  alias LineSdk.Model

  @type message_object :: Model.TextMessage.t() | Model.ImageMessage.t()
  @type event :: Model.MessageEvent.t()
end
