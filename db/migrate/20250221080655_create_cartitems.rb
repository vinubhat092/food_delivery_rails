class CreateCartitems < ActiveRecord::Migration[8.0]
  def change
    create_table :cartitems do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :menuitem, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
