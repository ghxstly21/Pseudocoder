# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user!, only: [ :edit, :update ]
  before_action :set_user, only: [ :edit, :update ]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to login_path, notice: "Account created successfully! Please log in."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if update_password?
      if @user.authenticate(params[:user][:current_password])
        @user.password = params[:user][:password]
        @user.password_confirmation = params[:user][:password_confirmation]
        if @user.save
          redirect_to home_path, notice: "Password updated successfully!"
        else
          @user.errors.add(:password, "could not be updated")
          render :edit, status: :unprocessable_entity
        end
      else
        @user.errors.add(:current_password, "is incorrect")
        render :edit, status: :unprocessable_entity
      end
    else
      if @user.update(user_params_profile)
        redirect_to home_path, notice: "Profile updated successfully!"
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def update_password?
    params.dig(:user, :password).present? || params.dig(:user, :password_confirmation).present?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def user_params_profile
    params.require(:user).permit(:name, :email)
  end

  def authenticate_user!
    redirect_to login_path, alert: "You must log in first" unless current_user.present?
  end
end
