class User < ApplicationRecord
    has_secure_password
    has_one_attached :profile_photo
    enum :role, { admin: 0, foodie: 1, delivery_agent: 2 }, default: :foodie
    validates :email, presence:true, uniqueness:true
    validates :password, presence:true
    validates :name, presence:true
    validates :role, presence:true

    def create_cart(restaurant_id:)
        Cart.create(user:self,restaurant_id:restaurant_id)
    end

    def cart
        @cart ||= Cart.find_by(user:self)
    end
end
