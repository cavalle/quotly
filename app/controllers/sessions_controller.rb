class SessionsController < ApplicationController
  def new
  end

  def create
    strategy = request.env['omniauth.strategy']
    auth     = request.env['omniauth.auth']
    session[:user_external_uid] = "#{strategy.name}:#{auth['uid']}"
    if current_user.present?
      redirect_to root_path
    else
      redirect_to new_user_path(auth['user_info'])
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
