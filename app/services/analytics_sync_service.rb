class AnalyticsSyncService
  def self.sync_order_stats
    Order.includes(orderitems: :menuitem).find_each do |order|
      order.orderitems.each do |item|
        Analytics::OrderStat.create!(
          order_id: order.id,
          restaurant_id: order.restaurant_id,
          menuitem_id: item.menuitem_id,
          menuitem_name: item.menuitem.name,
          category: item.menuitem.category,
          quantity: item.quantity,
          order_date: order.created_at.to_date,
        )
      end
    end
  end
end 