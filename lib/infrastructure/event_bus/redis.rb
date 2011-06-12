class EventBus::Redis
  def redis
    if ENV["REDISTOGO_URL"]
      uri = URI.parse(ENV["REDISTOGO_URL"])
      Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
    else
      Redis.new
    end
  end

  def publish(event)
    redis.publish "events", event.id
  end

  def subscriptions(event_name)
    @subscriptions ||= Hash.new
    @subscriptions[event_name.to_s] ||= Set.new
  end

  def subscribe(event_name, &handler)
    subscriptions(event_name.to_s) << handler
  end

  def wait_for_events
    sleep(0.02) # next_tick
  end

  def purge
    redis.del "events"
  end

  def start
    redis.subscribe("events") do |on|
      on.message do |channel, event_id|
        event = Event.find(event_id)
        subscriptions(event.name).each do |subscription|
          subscription.call(event.data)
        end
      end
    end
  end

  def stop; end
end