defmodule LineSdk.Model.Source do
  alias LineSdk.Model
  @type t :: Model.SourceUser.t() | Model.SourceGroup.t() | Model.SourceRoom.t()
end
