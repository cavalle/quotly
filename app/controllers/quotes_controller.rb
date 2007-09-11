class QuotesController < ApplicationController
  def index    
    if login = params[:user_id]
      user = User.find_by_login(login)
      @title = "Quotes published by #{user.login}"
      @quotes = user.quotes.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
    elsif author = params[:author_id]
      @title = "Quotes by #{author}"
      @quotes = Quote.paginate_by_author author, :page => params[:page], :per_page => 10, :order => 'created_at DESC'
    else
      @title = "Latest quotes"
      @quotes = Quote.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
    end
  end
  
  def create
    @quote = current_user.quotes.create(params[:quote])
    if @quote
      render :partial => 'quote', :quote => @quote    
    end
  end
end
