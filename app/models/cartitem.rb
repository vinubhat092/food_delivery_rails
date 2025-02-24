class Cartitem < ApplicationRecord
  belongs_to :cart
  belongs_to :menuitem

  validates :quantity,presence:true,numericality:{greater_than:0}
  validates :menuitem_id,presence:true
end
