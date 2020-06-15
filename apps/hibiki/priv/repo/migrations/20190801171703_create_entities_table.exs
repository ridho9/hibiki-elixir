defmodule Hibiki.Repo.Migrations.CreateEntitiesTable do
  use Ecto.Migration

  def change do
    create table(:entities) do
      add(:line_id, :string)
      add(:type, :string)
    end

    alter table(:tag) do
      remove(:scope_type)
      remove(:scope_id)
      remove(:creator_id)

      add(:creator_id, references(:entities))
      add(:scope_id, references(:entities))

      add(:value, :string)
    end

    rename(table(:tag), to: table(:tags))

    create(unique_index(:tags, [:scope_id, :name]))
  end
end
