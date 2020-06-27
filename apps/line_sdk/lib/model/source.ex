defmodule LineSdk.Model.Source do
  alias LineSdk.Model
  @type t :: Model.SourceUser.t() | Model.SourceGroup.t() | Model.SourceRoom.t()

  @spec user_id(t()) :: String.t()
  def user_id(%{user_id: id}), do: id

  @spec id(t) :: String.t()
  def id(source)

  def id(%LineSdk.Model.SourceUser{user_id: res}), do: res
  def id(%LineSdk.Model.SourceGroup{group_id: res}), do: res
  def id(%LineSdk.Model.SourceRoom{room_id: res}), do: res
end
