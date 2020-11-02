defmodule Hibiki.Entity do
  use Ecto.Schema

  import Ecto.Changeset
  alias Hibiki.Repo
  alias Hibiki.Entity

  schema "entities" do
    field(:line_id, :string)
    field(:type, :string)

    has_many(:created_tags, Hibiki.Tag, foreign_key: :creator_id)
    has_many(:scope_tags, Hibiki.Tag, foreign_key: :scope_id)
  end

  @type t :: %__MODULE__{
          line_id: String.t(),
          type: String.t()
          # created_tags: [Hibiki.Tag.t()],
          # scope_tags: [Hibiki.Tag.t()]
        }

  def changeset(struct, params) do
    struct
    |> cast(params, [:line_id, :type])
    |> validate_required([:line_id, :type])
    |> validate_inclusion(:type, ["global", "user", "group", "room"])
    |> unique_constraint(:line_id)
    |> unique_constraint(:id)
  end

  def global() do
    get("global")
  end

  @spec get(String.t()) :: Entity.t() | nil
  def get(line_id) do
    Hibiki.Entity
    |> Repo.get_by(line_id: line_id)
  end

  @spec create_or_get(String.t(), String.t()) :: Entity.t()
  def create_or_get(line_id, type) do
    case get(line_id) do
      nil ->
        {:ok, entity} = create(line_id, type)
        entity

      entity ->
        entity
    end
  end

  @spec create(String.t(), String.t()) :: {:ok, t} | {:error, any}
  def create(line_id, type) when is_atom(type) do
    create(line_id, "#{type}")
  end

  def create(line_id, type) do
    %__MODULE__{}
    |> changeset(%{line_id: line_id, type: type})
    |> Repo.insert()
  end

  @spec admin?(t) :: boolean
  def admin?(entity) do
    entity.line_id in Hibiki.Config.admin_id()
  end

  @spec from_source(LineSdk.Model.Source.t()) :: Entity.t()
  def from_source(source)

  def from_source(%LineSdk.Model.SourceUser{user_id: line_id}) do
    create_or_get(line_id, "user")
  end

  def from_source(%LineSdk.Model.SourceGroup{group_id: line_id}) do
    create_or_get(line_id, "group")
  end

  def from_source(%LineSdk.Model.SourceRoom{room_id: line_id}) do
    create_or_get(line_id, "room")
  end

  @spec user_from_source(LineSdk.Model.Source.t()) :: Entity.t()
  def user_from_source(%{user_id: line_id}) do
    create_or_get(line_id, "user")
  end
end
