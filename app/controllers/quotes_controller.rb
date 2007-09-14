class QuotesController < ApplicationController
  before_filter :login_required, :except => :index
  
  def index    
    options = { :page => params[:page], :per_page => 10, :order => 'created_at DESC' }
    
    if login = params[:user_login]
      user = User.find_by_login(login)
      @title = "Quotes published by #{user.login}"
      @quotes = user.quotes.paginate options
      @rss_url = user_quotes_url(login, :format => :rss)
    elsif author = params[:author_name]
      @title = "Quotes by #{author}"
      @quotes = Quote.paginate_by_author author, options
      @rss_url = author_quotes_url(author, :format => :rss)
    else
      @title = "Latest quotes"
      @quotes = Quote.paginate options
      @rss_url = quotes_url(:format => :rss)
    end  
    
    respond_to do |format|
      format.html
      format.rss  { render :layout => false }
      format.xml  { render :xml => @quotes.to_xml }
    end
  end
  
  def create    
    @quote = current_user.quotes.create(params[:quote])    
    respond_to do |format|
      format.html { redirect_to quotes_path }
      format.js
    end
  end
  
  def show
    @quote = Quote.find(params[:id])
  end
end
