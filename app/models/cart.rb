class Cart < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :cartitems, dependent: :destroy

  accepts_nested_attributes_for :cartitems, allow_destroy: true

  validates :restaurant_id,presence:true

end
