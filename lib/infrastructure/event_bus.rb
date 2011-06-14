module EventBus
  class << self
    attr_accessor :current
    delegate :publish, :subscribe, :wait_for_events, :start, :purge, :stop, :to => :current

    def init
      EventBus.current = Rails.configuration.event_bus.constantize.new
      Rails.configuration.event_subscribers.each do |dir|
        Dir[Rails.root.join(dir).join('**', '*.rb')].each(&method(:require_or_load))
      end
    end
  end
end
