class AbandonedCartNotificationJob < ApplicationJob
  queue_as :default


  def perform
    begin
      carts = Cart.joins(:cartitems)
                  .where('carts.updated_at <= ?', 1.minute.ago)
                  .distinct
      
      carts.find_each do |cart|
        if cart.user&.email.present?
          begin
            UserMailer.cart_abandoned(cart.user).deliver_now
          rescue => e
            Rails.logger.error "Failed to send email for cart #{cart.id}: #{e.message}"
            Rails.logger.error e.backtrace.join("\n")
          end
        else
          Rails.logger.info "Skipping cart #{cart.id} - no user email"
        end
      end
    rescue => e
      Rails.logger.error "Job failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise e
    end
    
  end
end 