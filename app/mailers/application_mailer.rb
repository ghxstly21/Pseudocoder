class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAIL_FROM", "noreply@pseudocoder.com")
  layout "mailer"
end
