ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'capybara/rails'
require 'turn'

MiniTest::Unit::TestCase.send :include, Capybara::DSL
MiniTest::Unit::TestCase.send :include, Delorean

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each {|f| require f}

class MiniTest::Unit::TestCase
  def setup
    DatabaseCleaner.clean_with :truncation
    Redis::Objects.redis.flushdb

    unless EventBus.current.is_a?(EventBus::InProcess)
      @bus_process = fork { EventBus.start } 
    end
  end

  def teardown
    Process.kill('KILL', @bus_process) if @bus_process

    Capybara.reset_sessions!
    Capybara.use_default_driver

    EventBus.purge
  end
end

Capybara.app = Proc.new { |env|
  EventBus.wait_for_events; 
  Rails.application.call(env)
}
