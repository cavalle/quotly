source "http://rubygems.org"
disable_rubygems

gem "sinatra", :require_as => 'sinatra/base'
gem "mustache", ">= 0.9.0", :require_as => 'mustache/sinatra'
gem "redis"
gem "activesupport", :require_as => 'active_support'
gem "i18n", ">= 0.1.3", :require_as => nil
gem "builder", "~> 2.1.2", :require_as => nil
gem "rack-openid", :require_as => 'rack/openid'
gem "RedCloth"

only :test do
  gem "steak"
  gem "capybara", :require_as => %w{capybara capybara/dsl}
  gem "faker"
  gem "celerity", :require_as => []
  gem "culerity", :require_as => []
end
