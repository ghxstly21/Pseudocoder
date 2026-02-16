class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      session[:guest_session] = false
      redirect_to home_path
    else
      flash[:alert] = "Invalid email or password"
      redirect_to login_path
    end
  end

  def guest_login
    guest_name ="Guest"
    session[:user_id] = nil
    session[:guest_session] = true
    session[:guest_name] = guest_name
    redirect_to home_path
  end

  def destroy
    session[:user_id] = nil
    session[:guest_session] = false
    session[:guest_name] = nil
    redirect_to root_path, notice: "Logged out successfully"
  end
end
