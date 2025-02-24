class ChangeCategoryoInteger < ActiveRecord::Migration[8.0]
  def change
    change_column :menuitems, :category, :integer, using: 'category::integer'
  end
end
