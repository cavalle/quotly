require File.dirname(__FILE__) + "/vendor/gems/environment.rb"
Bundler.require_env

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
    
    use Rack::Session::Cookie
    use Rack::OpenID
    
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
      session[:user] = User.create!(:nickname => params[:nickname], :identity_url => session[:identity_url])
      redirect '/'
    end
    
    post '/login' do
      if resp = request.env["rack.openid.response"]
        if resp.status == :success
          session[:identity_url] = resp.identity_url
          if session[:user] = User.by_identity_url(resp.identity_url)
            redirect '/'
          else
            redirect '/register'
          end
        else
          "Login not succesful #{resp.status}"
        end
      else
        headers 'WWW-Authenticate' => Rack::OpenID.build_header(params.merge({:required => 'email'}))
        throw :halt, [401, 'got openid?']
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
          
      end
      
      class QuoteIndex < Mustache
        def quotes
          @quotes.map do |quote|
            { :text => quote[:text],
              :author => quote[:author],
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
      data = encode(params)
      redis.lpush "quotes:quotes:all", params[:id]
      redis.lpush "quotes:quotes:nickname:#{params[:user][:nickname]}", params[:id]
      redis.set "quotes:quotes:id:#{params[:id]}", data
      params
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
      data = encode(params)
      raise unless params[:user] == by_id(params[:id])[:user]
      redis.set "quotes:quotes:id:#{params[:id]}", data
      params
    end
    
  end
  
  class User < Model
    def self.by_identity_url(identity_url)
      decode redis["quotes:users:identity_url:#{identity_url}"]
    end
    
    def self.by_nickname(nickname)
      decode redis["quotes:users:nickname:#{nickname}"]
    end
    
    def self.create!(params)
      data = encode(params)
      redis["quotes:users:nickname:#{params[:nickname]}"] = data
      redis["quotes:users:identity_url:#{params[:identity_url]}"] = data
      params
    end
  end

end