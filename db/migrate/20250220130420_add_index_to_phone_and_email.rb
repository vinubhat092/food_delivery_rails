class AddIndexToPhoneAndEmail < ActiveRecord::Migration[8.0]
  def change
    add_index :restaurants, :phone, unique:true
    add_index :restaurants, :email, unique:true
  end
end
