defmodule Hibiki.Repo.Migrations.TagTypeText do
  use Ecto.Migration

  def change do
    alter table(:tags) do
      modify(:value, :text)
    end
  end
end
