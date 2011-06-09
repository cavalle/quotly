module Entity

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def build_from(uid, events)
      object = self.allocate
      object.instance_variable_set :@uid, uid
      events.each do |event|
        object.send :do_apply, event
      end
      object
    end

    def new_uid
      UUIDTools::UUID.timestamp_create.to_s
    end

    def find(uid)
      events = Event.where(:aggregate_uid => uid.to_s)
      raise "Entity not found (no events)" if events.empty?
      self.build_from(uid, events)
    end

  end

  def uid
    @uid ||= self.class.new_uid
  end

  def method_missing(meth, *args, &blk)
    if meth.to_s =~ /^should_([^_]+)(_.+)?/
      verb = $1
      predicate = $2
      method = "#{third_personize(verb)}#{predicate}?"
      raise "#{self.class.name.titleize} should #{verb}#{([predicate.try(:humanize)] + args).compact.join(" ")}" unless self.send(method, *args)
    else
      super
    end
  end

  def apply_event(name, attributes = {})
    event = Event.new(:name => name, :data => attributes, :aggregate_uid => uid)

    do_apply event
    save event
    publish event
  end

private

  def do_apply(event)
    handler_name = "on_#{event.name.to_s.underscore}".sub(/_event/,'')
    if respond_to?(handler_name, true)
      handler = method(handler_name)
      handler.arity == 0 ? handler.call : handler.call(event.data)
    end
  end

  def third_personize(verb)
    case verb
    when /have/ then "has"
    when /be/ then "is"
    when /s$/ then verb
    else
      "#{verb}s"
    end
  end

  def save(event)
    event.save
  end

  def publish(event)
    EventBus.publish(event)
  end
end
