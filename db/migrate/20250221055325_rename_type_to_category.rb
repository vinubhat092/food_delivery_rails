class RenameTypeToCategory < ActiveRecord::Migration[8.0]
  def change
    rename_column :menuitems, :type, :category
  end
end
