class SessionsController < ApplicationController
  def create
    @user = User.find_or_create_from_auth_hash(env['omniauth.auth'])
    session[:user_id] = @user.id
    redirect_to :me
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end