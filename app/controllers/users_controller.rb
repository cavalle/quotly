class UsersController < ApplicationController
  def new
    uid = session[:user_external_uid]
    reset_session
    session[:user_external_uid] = uid
    @user = { :nickname => params[:nickname] }
  end

  def create
    User.new params[:user].merge(:external_uid => session[:user_external_uid])
    redirect_to root_path
  end

  def show
    @user = UserPresenter.find(params[:nickname])
  end
end
