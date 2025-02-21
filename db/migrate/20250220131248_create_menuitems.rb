class CreateMenuitems < ActiveRecord::Migration[8.0]
  def change
    create_table :menuitems do |t|
      t.string :name
      t.text :description
      t.string :type
      t.boolean :active

      t.timestamps
    end
  end
end
