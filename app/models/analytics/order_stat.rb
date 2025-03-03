module Analytics
  class OrderStat
    include Mongoid::Document
    include Mongoid::Timestamps

    field :order_id, type: Integer
    field :restaurant_id, type: Integer
    field :menuitem_id, type: Integer
    field :menuitem_name, type: String
    field :category, type: String
    field :quantity, type: Integer
    field :order_date, type: Date

    index({ restaurant_id: 1, order_date: -1 })
    index({ menuitem_id: 1 })
    index({ category: 1 })
  end
end 