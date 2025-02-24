class Orderitem < ApplicationRecord
  belongs_to :order
  belongs_to :menuitem

  validates :quantity,presence:true,numericality:{greater_than:0}
end
