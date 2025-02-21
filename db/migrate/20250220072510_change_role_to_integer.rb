class ChangeRoleToInteger < ActiveRecord::Migration[8.0]
  def change
    change_column :users, :role, 'integer USING role::integer', default: 1
  end
end
