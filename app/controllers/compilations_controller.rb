class CompilationsController < ApplicationController
  before_action :authenticate_user!
  # before_action :find_compilation, only: [ :destroy ]

  private
  def authenticate_user!
    redirect_to root_path, alert: "You must log in to compile code" unless logged_in?
  end
end
