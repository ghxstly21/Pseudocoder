class PasswordResetsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:email])

    if user
      user.generate_reset_token
      UserMailer.password_reset_email(user).deliver_now
      redirect_to login_path, notice: "Password reset link sent to your email"
    else
      redirect_to forgot_password_path, alert: "Email not found"
    end
  end

  def edit
    @user = User.find_by(reset_token: params[:token])

    unless @user
      redirect_to login_path, alert: "Invalid reset link"
      return
    end

    if @user.reset_token_expired?
      redirect_to forgot_password_path, alert: "Reset link has expired"
    end
  end

  def update
    @user = User.find_by(reset_token: params[:token])

    unless @user
      redirect_to login_path, alert: "Invalid reset link"
      return
    end

    if @user.reset_token_expired?
      redirect_to forgot_password_path, alert: "Reset link has expired"
      return
    end

    if @user.update(password: params[:user][:password], password_confirmation: params[:user][:password_confirmation])
      @user.clear_reset_token
      redirect_to login_path, notice: "Password reset successfully! Please log in."
    else
      render :edit, status: :unprocessable_entity
    end
  end
end
