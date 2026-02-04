require "ostruct"

class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    if session[:guest_session]
      @current_user = OpenStruct.new(
        id: nil,
        name: session[:guest_name] || "Guest",
        compilations: []
      )
    else
      @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
    end
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to root_path, alert: "You must log in first" unless logged_in?
  end

  def authenticate_user!
    redirect_to login_path, alert: "You must log in first" unless current_user.present?
  end
end
