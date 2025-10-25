# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  def current_user
    # memoize the current user if session[:user_id] exists
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    redirect_to login_path, alert: "You must log in first" unless logged_in?
  end
end
