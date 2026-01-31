class PagesController < ApplicationController
  def home
    if current_user && session[:guest_session] != true
      @compilations = current_user.compilations.order(created_at: :desc)
    else
      @compilations = []
    end
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
    redirect_to contact_path
  end
end
