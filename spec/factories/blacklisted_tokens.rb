FactoryBot.define do
  factory :blacklisted_token do
    token { "MyString" }
    expiry { "2025-02-27 11:34:01" }
  end
end
