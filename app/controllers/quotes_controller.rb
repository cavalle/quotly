class QuotesController < ApplicationController
  def new
  end

  def show
    @presenter = QuotePresenter.find(params[:id])
  end

  def create
    Quote.new params.slice(:author, :text, :source).merge(current_user.slice(:nickname))
    redirect_to "/#{current_user[:nickname]}"
  end

  def edit
    @presenter = QuotePresenter.find(params[:id])
  end

  def update
    Quote.find(params[:id]).amend(params.slice(:author, :text, :source))
    redirect_to :root
  end

end
