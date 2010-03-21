require File.dirname(__FILE__) + "/vendor/gems/environment.rb"
Bundler.require_env
require File.dirname(__FILE__) + "/lib/rack/auth"

module Quotes
  def self.redis
    @redis ||= Redis.new
  end
  
  def self.clear_data
    keys = redis.keys("quotes:*")
    keys.each {|key| redis.del(key)}
  end

  class App < Sinatra::Base
    register Mustache::Sinatra
    
    APP_CONFIG = YAML.load_file(File.dirname(__FILE__) + "/config/config.yml").freeze
    
    use Rack::Session::Cookie
    use Rack::OpenID
    use Rack::Auth::FacebookConnect, APP_CONFIG[:facebook]

    set :views, File.dirname(__FILE__) + "/templates"
    set :public, File.dirname(__FILE__) + "/public"
    set :static, true
    set :methodoverride, true

    before do
      @current_user = session[:user]
    end
    
    get "/" do
      @quotes = Quote.latest
      mustache :quote_index
    end
    
    get "/quotes/new" do
      mustache :new_quote
    end
    
    get "/quotes/:id/edit" do |id|
      @quote = Quote.by_id(id)
      mustache :edit_quote
    end
    
    post "/quotes" do
      Quote.create!(params.merge(:user => @current_user))
      redirect "/#{@current_user[:nickname]}"
    end
    
    put "/quotes/:id" do |id|
      Quote.update(params.merge(:user => @current_user, :id => id))
      redirect "/"
    end
    
    get '/authors' do
      Quote.all.map{|q|q[:author]}.select{|a|a.downcase.include?(params[:q].downcase)}.uniq.flatten.to_json
    end
    
    get '/sources' do
      Quote.all.map{|q|q[:source]}.select{|s|s.downcase.include?(params[:q].downcase)}.uniq.flatten.to_json
    end
    
    get '/login' do
      mustache :login
    end
    
    get '/logout' do
      session[:user] = nil
      redirect back
    end
    
    get '/register' do
      mustache :register
    end
    
    post '/register' do
      session[:user] = User.create!(:nickname => params[:nickname], :external_id => session[:external_id])
      redirect '/'
    end
    
    post '/login' do
      if resp = request.env["rack.openid.response"] || request.env["rack.facebook.response"]
        if resp.status == :success
          session[:external_id] = resp.external_id
          if session[:user] = User.by_external_id(resp.external_id)
            redirect '/'
          else
            redirect '/register'
          end
        else
          "Login not succesful #{resp.status}"
        end
      else
        headers 'WWW-Authenticate' => Rack::Auth.build_header(params)
        throw :halt, [401, 'auth required']
      end
    end
    
    get "/:nickname" do |nickname|
      return not_found unless @user = User.by_nickname(nickname)
      @quotes = Quote.by_user(@user)
      mustache :user_show
    end
    
    not_found do
      "Page not found"
    end
    
    module Views
      class Layout < Mustache
        def logged_in?
          @current_user
        end
        
        def anonymous?
          @current_user.blank?
        end
      end
      
      class EditQuote < Mustache
        
        def quote_path
          "/quotes/#{@quote[:id]}"
        end
        
        def text
          @quote[:text]
        end
        
        def author
          @quote[:author]
        end
        
        def source
          @quote[:source]
        end
          
      end
      
      class QuoteIndex < Mustache
        def quotes
          @quotes.map do |quote|
            { :text => quote[:html_text],
              :author => quote[:author],
              :source => quote[:source],
              :source? => quote[:source].present?,
              :size => case quote[:text].length
                       when (0..40): "extra-small"
                       when (40..100): "small"
                       when (100..250): "medium"
                       when (250..500): "large"
                       else "extra-large"
                       end,
              :edit_path => "/quotes/#{quote[:id]}/edit",
              :amendable? => quote[:user] == @current_user
            }
          end
        end
      end
      
      class UserShow < QuoteIndex
        
        def nickname
          @user[:nickname]
        end
        
        def no_quotes?
          @quotes.empty?
        end
      end
    end

  end
  
  class Model
    def self.redis
      Quotes.redis
    end
    
    def self.encode(hash)
      hash.to_yaml
    end
    
    def self.decode(data)
      data && YAML.load(data).symbolize_keys
    end
  end

  class Quote < Model
  
    def self.create!(params)
      params.merge! :id => redis.incr("quotes:quotes:last_id")
      params[:html_text] = RedCloth.new(params[:text]).to_html
      data = encode(params)
      redis.lpush "quotes:quotes:all", params[:id]
      redis.lpush "quotes:quotes:nickname:#{params[:user][:nickname]}", params[:id]
      redis.set "quotes:quotes:id:#{params[:id]}", data
      params
    end
    
    def self.all
      range = redis.lrange "quotes:quotes:all", 0, -1
      range.map{ |id| by_id(id) }
    end
  
    def self.latest
      range = redis.lrange "quotes:quotes:all", 0, 19
      range.map{ |id| by_id(id) }
    end
    
    def self.by_user(user)
      range = redis.lrange "quotes:quotes:nickname:#{user[:nickname]}", 0, -1
      range.map{ |id| by_id(id) }
    end
    
    def self.by_id(id)
      data = redis.get "quotes:quotes:id:#{id}"
      decode(data)
    end
    
    def self.update(params)
      params[:html_text] = RedCloth.new(params[:text]).to_html
      data = encode(params)
      raise unless params[:user] == by_id(params[:id])[:user]
      redis.set "quotes:quotes:id:#{params[:id]}", data
      params
    end
    
  end
  
  class User < Model
    def self.by_external_id(external_id)
      decode redis["quotes:users:identity_url:#{external_id}"]
    end
    
    def self.by_nickname(nickname)
      decode redis["quotes:users:nickname:#{nickname}"]
    end
    
    def self.create!(params)
      data = encode(params)
      redis["quotes:users:nickname:#{params[:nickname]}"] = data
      redis["quotes:users:identity_url:#{params[:external_id]}"] = data
      params
    end
  end

end