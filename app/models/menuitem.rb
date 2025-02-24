class Menuitem < ApplicationRecord
    has_one_attached :image
    has_and_belongs_to_many :restaurants
    has_many :cartitems
    has_many :carts, through: :cartitems
    has_many :orders, through: :carts
    has_many :orderitems
    enum :category, { starters: 0, main_course: 1, desert:2 } ,default:0
    validates :name,presence:true
    validates :category,presence:true

end
