class ContactMailer < ApplicationMailer
  def contact_email(first_name, last_name, email, phonenumber, subject)
    @first_name = first_name
    @last_name = last_name
    @email = email
    @phonenumber = phonenumber
    @subject = subject

    mail(
      to: "zalavadiyadharma@gmail.com",
      subject: "Customer Support Request: #{@first_name} #{@last_name}"
    )
  end
end
