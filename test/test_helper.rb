ENV['RAILS_ENV'] = 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'minitest/autorun'
require 'capybara/rails'

MiniTest::Unit::TestCase.send :include, Capybara
MiniTest::Unit::TestCase.send :include, Delorean

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each {|f| require f}

class MiniTest::Unit::TestCase
  def setup
    Redis::Objects.redis.flushdb
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
