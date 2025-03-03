class CreateBlacklistedTokens < ActiveRecord::Migration[8.0]
  def change
    create_table :blacklisted_tokens do |t|
      t.string :token
      t.datetime :expiry

      t.timestamps

    end
  end
end
