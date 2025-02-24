class Restaurant < ApplicationRecord
  belongs_to :user
  has_and_belongs_to_many :menuitems
  has_one_attached :profile_photo
  has_many :order

  validates :name,presence:true
  validates :address,presence:true
  validates :phone,presence:true,uniqueness:true
  validates :email,presence:true,uniqueness:true
end
