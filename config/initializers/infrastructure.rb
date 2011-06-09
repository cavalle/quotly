# Ohm.connect :url => ENV["REDISTOGO_URL"]
$redis = Redis.new

Rails.application.class.configure do
  config.event_bus = 'InProcessEventBus'
  config.event_subscribers = %w{HomePresenter}
  config.to_prepare { EventBus.init }
end
