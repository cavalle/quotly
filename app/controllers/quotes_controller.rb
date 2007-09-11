class QuotesController < ApplicationController
  def index
    @quotes = Quote.paginate :page => params[:page], :per_page => 10, :order => 'created_at DESC'
  end
  
  def create
    @quote = current_user.quotes.create(params[:quote])
    if @quote
      render :partial => 'quote', :quote => @quote    
    end
  end
end
