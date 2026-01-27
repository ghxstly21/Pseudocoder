class PagesController < ApplicationController
  def home
    @current_user = User.find(session[:user_id]) if session[:user_id]
  end
  def contactus
  end

  def contact_submit
    @first_name = params[:firstname]
    @last_name  = params[:lastname]
    @country    = params[:country]
    @subject    = params[:subject]


    ContactMailer.contact_email(@first_name, @last_name, @country, @subject).deliver_now

    flash[:notice] = "Thank you! Your message has been sent."
    redirect_to contactus_path
  end
end
