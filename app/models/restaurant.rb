class Restaurant < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_photo

  validates :name,presence:true
  validates :address,presence:true
  validates :phone,presence:true,uniqueness:true
  validates :email,presence:true,uniqueness:true
end
