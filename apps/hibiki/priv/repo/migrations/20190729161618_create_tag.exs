defmodule Hibiki.Repo.Migrations.CreateTag do
  use Ecto.Migration

  def change do
    create table(:tag) do
      add(:name, :string)
      add(:type, :string)

      add(:creator_id, :string)

      add(:scope_type, :string)
      add(:scope_id, :string)

      timestamps()
    end

    create(unique_index(:tag, [:scope_id, :name]))
  end

  def down do
    drop(table(:tag))
  end
end
