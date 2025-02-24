class Menuitem < ApplicationRecord
    has_one_attached :image
    has_and_belongs_to_many :restaurants
    enum :category, { veg: 0, non_veg: 1 } ,default:0
    validates :name,presence:true
    validates :category,presence:true
    
end
