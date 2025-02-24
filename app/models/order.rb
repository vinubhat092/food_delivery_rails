class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :orderitems, dependent: :destroy

end
