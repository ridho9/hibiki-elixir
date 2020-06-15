defmodule Hibiki.Repo.Migrations.EntityAddConstraint do
  use Ecto.Migration

  def change do
    create(unique_index(:entities, [:line_id]))
  end
end
