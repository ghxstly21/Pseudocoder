class EmailChangesController < ApplicationController
  before_action :authenticate_user!, only: :create

  def create
    user = current_user
    new_email = params[:new_email]

    if user.initiate_email_change(new_email)
      UserMailer.email_change_confirmation(user).deliver_now
      redirect_to home_path, notice: "Confirmation email sent to #{new_email}"
    else
      redirect_to edit_user_path(user), alert: "Email already in use or invalid"
    end
  end

  def confirm
    user = User.find_by(email_confirmation_token: params[:token])

    unless user
      redirect_to login_path, alert: "Invalid confirmation link"
      return
    end

    if user.confirm_email_change(params[:token])
      redirect_to home_path, notice: "Email changed successfully!"
    else
      redirect_to login_path, alert: "Could not confirm email change"
    end
  end
end
