defprotocol LineSdk.MessageObject do
  @spec to_object(any) :: any
  def to_object(any)
end
