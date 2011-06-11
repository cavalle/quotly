class QuotesController < ApplicationController
  
  def new
  end

  def show
    @quote = QuotePresenter.find(params[:id])
  end

  def create
    Quote.new params[:quote].merge(current_user.slice(:nickname))
    redirect_to user_path(current_user[:nickname])
  end

  def edit
    @quote = QuotePresenter.find(params[:id])
  end

  def update
    Quote.find(params[:id]).amend(params[:quote])
    redirect_to :root
  end

end
