# encoding: UTF-8
class HomeController < ApplicationController
  def show
    @home = HomePresenter.find
  end
end
