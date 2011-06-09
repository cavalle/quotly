module EventHandler
  def handlers
    @handlers ||= Hash.new {|h,k| h[k] = Set.new}
  end

  def on(*events, &block)
    events.each do |event_name|
      handlers[event_name.to_s] << block

      ::EventBus.subscribe(event_name) do |event|
        begin
          self.handling_event = true
          block.call(event)
        ensure
          self.handling_event = false
        end
      end
    end
  end

  def apply_events
    ::Event.where(:name => handlers.keys).each do |event|
      handlers[event.name.to_s].each do |handler|
        handler.call(event.data)
      end
    end
  end

  def handling_event?
    Thread.current["handling_event"]
  end

  def handling_event=(value)
    Thread.current["handling_event"] = value
  end
end
