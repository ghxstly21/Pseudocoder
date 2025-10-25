class DashboardController < ApplicationController
  before_action :require_login

  def index
    # you can pass current_user to the view if needed
  end
end
