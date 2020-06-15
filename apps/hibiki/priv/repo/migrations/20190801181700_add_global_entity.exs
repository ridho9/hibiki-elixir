defmodule Hibiki.Repo.Migrations.AddGlobalEntity do
  use Ecto.Migration

  def up do
    execute(~s| insert into entities values (1, 'global', 'global'); |)
  end

  def down do
    execute(~s| delete from entities where id = 1; |)
  end
end
