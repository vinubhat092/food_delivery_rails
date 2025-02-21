class ChangeAdressToAddress < ActiveRecord::Migration[8.0]
  def change
    rename_column :restaurants, :adress, :address
  end
end
