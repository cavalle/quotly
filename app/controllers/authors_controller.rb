class AuthorsController < ApplicationController
  def index
    render :json => AutocompletePresenter.search_authors(params[:q])
  end
end
