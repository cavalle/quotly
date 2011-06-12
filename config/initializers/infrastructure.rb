# Ohm.connect :url => ENV["REDISTOGO_URL"]
$redis = Redis.new

Rails.application.class.configure do
  config.event_bus = 'EventBus::InProcess'
  config.event_subscribers = %w{} # No need in Rails 3.1 ?
  config.to_prepare { EventBus.init }
end
