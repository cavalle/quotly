class SourcesController < ApplicationController
  def index
    render :json => AutocompletePresenter.search_sources(params[:q])
  end
end
