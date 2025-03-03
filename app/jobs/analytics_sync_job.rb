class AnalyticsSyncJob < ApplicationJob
  queue_as :analytics

  def perform
    AnalyticsSyncService.sync_order_stats
  rescue => e
    Rails.logger.error "Analytics sync failed: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
  end
end 