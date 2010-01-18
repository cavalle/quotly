module Rack::Auth
  
  autoload :FacebookConnect, File.dirname(__FILE__) + '/auth/facebook_connect'
  
  def self.build_header(params)
    params[:provider] == "facebook" ? Rack::Auth::FacebookConnect.build_header : Rack::OpenID.build_header(params)
  end
  
end

module OpenID::Consumer::Response
  alias_method :external_id, :identity_url
end