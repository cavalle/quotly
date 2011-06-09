# encoding: UTF-8
class HomeController < ApplicationController
  def show
    @presenter = HomePresenter.find
  end
end
