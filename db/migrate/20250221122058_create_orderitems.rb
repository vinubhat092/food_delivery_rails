class CreateOrderitems < ActiveRecord::Migration[8.0]
  def change
    create_table :orderitems do |t|
      t.references :order, null: false, foreign_key: true
      t.references :menuitem, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
