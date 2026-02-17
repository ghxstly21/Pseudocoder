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
    @email    = params[:email]
    @phonenumber    = params[:phonenumber]
    @subject    = params[:subject]

    begin
      ContactMailer.contact_email(@first_name, @last_name, @email, @phonenumber, @subject).deliver_now
      flash[:notice] = "Thank you! Your message has been sent."
    rescue Errno::ECONNREFUSED => e
      flash[:alert] = "Unable to send email at this time. Please try again later or contact us directly at theofficialpseudocoder@gmail.com"
    rescue StandardError => e
      flash[:alert] = "An error occurred while sending your message. Please try again later."
    end

    redirect_to contact_path
  end
end
