class ChangeRoleToIntegers < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      ALTER TABLE users ALTER COLUMN role TYPE integer USING role::integer;
    SQL
    change_column_default :users, :role, 1
  end

  def down
    change_column :users, :role, :string
  end
end
