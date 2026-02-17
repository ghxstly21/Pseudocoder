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
      Rails.logger.info "=== SENDING EMAIL VIA RESEND ==="

      # Send email via Resend with deliver_later for async processing
      ContactMailer.contact_email(@first_name, @last_name, @email, @phonenumber, @subject).deliver_later

      Rails.logger.info "=== EMAIL QUEUED SUCCESSFULLY ==="
      flash[:notice] = "Thank you! Your message has been sent."
    rescue StandardError => e
      Rails.logger.error "=== EMAIL FAILED: #{e.class} ==="
      Rails.logger.error e.message
      Rails.logger.error e.backtrace.first(5).join("\n")
      flash[:alert] = "Unable to send your message at this time. Please try again later or contact us directly at theofficialpseudocoder@gmail.com"
    end

    redirect_to contact_path
  end
end
