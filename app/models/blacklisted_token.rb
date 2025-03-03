class BlacklistedToken < ApplicationRecord
  validates :token, presence: true, uniqueness: true
  validates :expiry, presence: true

  def self.invalid?(token)
    where(token: token).exists?
  end

  scope :expired, -> { where('expiry < ?', Time.current) }
end
