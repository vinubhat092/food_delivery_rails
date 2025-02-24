class AddIndexToNameInMenuitems < ActiveRecord::Migration[8.0]
  def change
    add_index :menuitems, :name
  end
end
