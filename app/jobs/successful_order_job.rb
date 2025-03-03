class SuccessfulOrderJob < ApplicationJob
  queue_as :default

  def perform(order_id)
    order = Order.find(order_id)
    if order.user&.email.present?
      begin
        UserMailer.order_successful(order.user).deliver_now
        Rails.logger.info "Successfully sent order confirmation to #{order.user.email} for order #{order.id}"
      rescue => e
        Rails.logger.error "Failed to send order confirmation for order #{order.id}: #{e.message}"
      end
    end
  rescue => e
    Rails.logger.error "Job failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end
end