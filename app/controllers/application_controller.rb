class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user

  def current_user
    @current_user ||= CurrentUserPresenter.find(session[:user_external_uid])
  end

end
