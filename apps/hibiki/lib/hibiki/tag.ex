defmodule Hibiki.Tag do
  use Ecto.Schema
  import Ecto.Query

  schema "tags" do
    field(:name, :string)
    field(:type, :string)
    field(:value, :string)

    belongs_to(:creator, Hibiki.Entity, foreign_key: :creator_id)
    belongs_to(:scope, Hibiki.Entity, foreign_key: :scope_id)

    timestamps()
  end

  @type t :: %__MODULE__{
          name: String.t(),
          type: String.t(),
          value: String.t()
        }

  def changeset(struct, params) do
    import Ecto.Changeset

    struct
    |> cast(params, [:name, :type, :value])
    |> validate_required([:name, :type, :value, :creator, :scope])
    |> validate_inclusion(:type, ["image", "text"])
    |> validate_length(:name, max: 20)
    |> validate_length(:value, max: 1000)
    |> validate_tag_image_value()
    |> validate_tag_name()
    |> unique_constraint(:name, name: :tags_scope_id_name_index)
  end

  def format_error(changeset) do
    changeset
    |> Ecto.Changeset.traverse_errors(fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {k, v} -> "#{k} #{v}" end)
    |> Enum.join(", ")
  end

  @spec create(String.t(), String.t(), String.t(), Hibiki.Entity.t(), Hibiki.Entity.t()) ::
          {:ok, Hibiki.Tag.t()} | {:error, any}
  def create(name, type, value, creator, scope) do
    %Hibiki.Tag{creator: creator, scope: scope}
    |> Hibiki.Tag.changeset(%{name: name, type: type, value: value})
    |> Hibiki.Repo.insert()
  end

  @spec delete(Hibiki.Tag.t()) :: {:ok, Hibiki.Tag.t()} | {:error, any}
  def delete(tag) do
    tag
    |> Hibiki.Repo.delete()
  end

  @spec update(Hibiki.Tag.t(), map) :: {:ok, Hibiki.Tag.t()} | {:error, any}
  def update(tag, changes) do
    tag
    |> Hibiki.Tag.changeset(changes)
    |> Hibiki.Repo.update()
  end

  @spec get_by_creator(Hibiki.Entity.t()) :: [Hibiki.Tag.t()]
  def get_by_creator(creator) do
    from(t in Hibiki.Tag,
      where: t.creator_id == ^creator.id
    )
    |> Hibiki.Repo.all()
  end

  @spec get_by_scope(Hibiki.Entity.t()) :: [Hibiki.Tag.t()]
  def get_by_scope(scope) do
    from(t in Hibiki.Tag,
      where: t.scope_id == ^scope.id
    )
    |> Hibiki.Repo.all()
  end

  @spec by_name(String.t(), Hibiki.Entity.t()) :: Hibiki.Tag.t() | nil
  def by_name(name, scope) do
    from(t in Hibiki.Tag,
      where: t.scope_id == ^scope.id,
      where: t.name == ^name
    )
    |> Hibiki.Repo.one()
  end

  @spec get_from_tiered_scope(String.t(), Hibiki.Entity.t(), Hibiki.Entity.t()) ::
          Hibiki.Tag.t() | nil
  def get_from_tiered_scope(name, scope, user) do
    scopes = [user, scope, Hibiki.Entity.global()]
    name = String.downcase(name)

    get_from_tiered_scope(name, scopes)
  end

  @spec get_from_tiered_scope(String.t(), [Hibiki.Entity.t()]) ::
          Hibiki.Tag.t() | nil
  def get_from_tiered_scope(name, scopes) do
    scopes
    |> Enum.dedup()
    |> Enum.reduce(nil, fn sc, acc ->
      acc || Hibiki.Tag.by_name(name, sc)
    end)
  end

  defp validate_tag_image_value(cs) do
    import Ecto.Changeset
    type = get_field(cs, :type)

    if type == "image" do
      validate_format(cs, :value, ~r|^https://|, message: "must starts with 'https://'")
    else
      cs
    end
  end

  defp validate_tag_name(cs) do
    import Ecto.Changeset
    name = get_field(cs, :name)

    if String.contains?(name, ["\n", "#"]) do
      add_error(cs, :name, "can't contain newline or #")
    else
      cs
    end
  end
end
