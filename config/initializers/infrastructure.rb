# Ohm.connect :url => ENV["REDISTOGO_URL"]
$redis = if ENV["REDISTOGO_URL"]
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else
  Redis.new
end

Rails.application.class.configure do
  config.event_bus = 'EventBus::InProcess'
  config.event_subscribers = %w{app/presenters}
  config.to_prepare { EventBus.init }
end
