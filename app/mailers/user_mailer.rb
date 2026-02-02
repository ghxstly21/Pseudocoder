class UserMailer < ApplicationMailer
  default from: "noreply@pseudocoder.com"

  def password_reset_email(user)
    @user = user
    @reset_url = reset_password_url(@user.reset_token)
    mail(to: @user.email, subject: "Reset Your Password")
  end

  def email_change_confirmation(user)
    @user = user
    @confirm_url = confirm_email_change_url(@user.email_confirmation_token)
    @new_email = @user.pending_email
    mail(to: @user.pending_email, subject: "Confirm Your Email Change")
  end
end
