class Event < ActiveRecord::Base
  serialize :data

  def data
    (super || {}).symbolize_keys
  end
end
