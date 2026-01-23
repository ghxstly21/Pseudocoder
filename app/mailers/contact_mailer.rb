class ContactMailer < ApplicationMailer
  default from: 'webmaster@yourdomain.com' 

  def contact_email(first_name, last_name, country, subject)
    @first_name = first_name
    @last_name = last_name
    @country = country
    @subject = subject

    mail(
      to: 'zalavadiyadharma@gmail.com',
      subject: "New Form Submission: #{@first_name} #{@last_name}"
    )
  end
end
