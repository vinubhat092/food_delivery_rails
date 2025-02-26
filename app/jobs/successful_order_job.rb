class SuccessfulOrderJob < ApplicationJob
  queue_as :default

  def perform
    begin
      Order.where('updated_at <=?',1.minute.ago ).find_each do |order|
        if order.user&.email.present?
          begin
            UserMailer.order_successful(order.user).deliver_now
            Rails.logger.info "Successfully sent order confirmation to #{order.user.email} for order #{order.id}"
          rescue => e
            Rails.logger.error "Failed to send order confirmation for order #{order.id}: #{e.message}"
          end
        end
      end
    rescue => e
      Rails.logger.error "Job failed: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end