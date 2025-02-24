class CreateJoinTableMenuitemsRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_join_table :menuitems, :restaurants do |t|
      # t.index [:menuitem_id, :restaurant_id]
      # t.index [:restaurant_id, :menuitem_id]
    end
  end
end
