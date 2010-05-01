require File.dirname(__FILE__) + '/../quotes'
Bundler.require :test

module Factories
  def create_quote(params = {})
    params = params.dup
    params[:text]   ||= Faker::Lorem.sentence
    params[:author] ||= Faker::Name.name
    params[:user]   ||= create_user
    Quotes::Quote.create!(params)
  end
  
  def create_user(params = {})
    params[:nickname]     ||= Faker::Internet.user_name
    params[:external_id]  ||= Faker::Internet.domain_name
    Quotes::User.create!(params)
  end
end

module Helpers
  def login_as(user)
    visit "/login"
    fill_in "OpenID", :with => user[:external_id]
    click_button "Go!"
  end
end

module Paths

end

class Rack::OpenID

  def call(env)
    if env["PATH_INFO"] == "/mock_openid_session"
      req = Rack::Request.new(env)
      env["REQUEST_METHOD"] = req.params["method"]
      env["PATH_INFO"] = req.params["return"]
      env["rack.openid.response"] = Struct.new(:status, :external_id).new(:success, req.params["id"])
    end
    
    status, headers, body = @app.call(env)

    if status.to_i == 401 && qs = headers[Rack::OpenID::AUTHENTICATE_HEADER]
      params = Rack::OpenID.parse_header(qs)
      identifier = params['identifier'] || params['identity']
      [303, {"Content-Type" => "text/html", "Location" => "/mock_openid_session?id=#{identifier}&return=#{env["PATH_INFO"]}&method=#{env["REQUEST_METHOD"]}"}, []]
    else
      [status, headers, body]
    end
  end
end

Spec::Runner.configure do |config|
  config.include Capybara
  config.include Factories
  config.include Helpers
  config.include Paths
  
  Capybara.app = Quotes::App.new
  
  config.before do
    Capybara.reset_sessions!
    Quotes.clear_data 
  end
end

module Capybara
  class Session
    def url
      driver.current_url
    end
    def path
      driver.current_path
    end
  end
end

class Capybara::Driver::RackTest
  public :current_path
end