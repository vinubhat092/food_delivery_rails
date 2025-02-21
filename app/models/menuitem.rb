class Menuitem < ApplicationRecord
    has_one_attched :image
    enum  type: {veg:0,non_veg:1}}
    validates :name,presence:true
    validates :type,presence:true
    
end
