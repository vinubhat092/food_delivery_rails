require 'sidekiq'
require 'sidekiq-scheduler'

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
  
  config.logger.level = Logger::DEBUG

  config.on(:startup) do
    schedule_file = Rails.root.join('config', 'schedule.yml')
    
    if File.exist?(schedule_file)
      Sidekiq.schedule = YAML.load_file(schedule_file)
    else
      Sidekiq.schedule = {
        'abandoned_cart_notification' => {
          'every' => '1m',
          'class' => 'AbandonedCartNotificationJob',
          'enabled': true
        }
      }
    end
    
    SidekiqScheduler::Scheduler.instance.reload_schedule!
  end
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0') }
end 