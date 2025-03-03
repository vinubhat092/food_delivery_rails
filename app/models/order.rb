class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :orderitems, dependent: :destroy

  after_create :sync_to_analytics

  private

  def sync_to_analytics
    orderitems.each do |item|
      Analytics::OrderStat.create!(
        order_id: id,
        restaurant_id: restaurant_id,
        menuitem_id: item.menuitem_id,
        menuitem_name: item.menuitem.name,
        category: item.menuitem.category,
        quantity: item.quantity,
        order_date: created_at.to_date,
        total_amount: item.quantity * item.menuitem.price
      )
    end
  rescue => e
    Rails.logger.error "Failed to sync order #{id} to analytics: #{e.message}"
  end
end
