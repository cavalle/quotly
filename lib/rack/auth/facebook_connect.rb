require 'md5'

module Rack::Auth
  class FacebookConnect
    def self.build_header
      'Facebook Connect'
    end
    
    class Response < Struct.new(:status, :external_id)
    end
    
    def initialize(app, config = {})
      @app = app
      @config = config
    end
    
    def call(env)
      req = Rack::Request.new(env)
      complete_authentication(req) if facebook_connect_request?(req)
      
      status, headers, body = @app.call(env)
      
      if status.to_i == 401 && facebook_connect_headers?(headers)
        begin_authentication(req)
      else
        [status, headers, body]
      end
    end
    
    private
    
    def facebook_connect_headers?(headers)
      headers["WWW-Authenticate"] == "Facebook Connect"
    end
    
    def begin_authentication(req)
      redirect_to("http://www.facebook.com/login.php?api_key=#{@config[:api_key]}&fbconnect=true&v=1.0&connect_display=page&next=#{req.path}?_method=#{req.request_method}")
    end
    
    def facebook_connect_request?(req)
      !!req.params["auth_token"]
    end
    
    def complete_authentication(req)
      params = { :method => "Auth.getSession",
                 :api_key => @config[:api_key],
                 :v => "1.0",
                 :auth_token => req.params["auth_token"] }
                 
      add_signature params

      resp = Net::HTTP.post_form(URI.parse("http://api.facebook.com/restserver.php"), params)
      result = Hash.from_xml(resp.body)["Auth_getSession_response"]

      req.env["rack.facebook.response"] = result ? Response.new(:success , result["uid"]) : Response.new(:error, nil)
      req.env["REQUEST_METHOD"] = req.params["_method"]
    end
    
    def add_signature(params)
      params_str = params.sort_by{|key, value| key.to_s}.map{|a|a.join("=")}.join
      params[:sig] = MD5.md5(params_str + @config[:secret])
    end
    
    def redirect_to(url)
      [303, {"Content-Type" => "text/html", "Location" => url}, []]
    end
        
  end
end
