class User < ApplicationRecord
    has_secure_password
    has_one_attached :profile_photo
    enum :role, { admin: 0, foodie: 1, delivery_agent: 2 }, default: :foodie
    validates :email, presence:true, uniqueness:true
    validates :password, presence:true
    validates :name, presence:true
    validates :role, presence:true
end
