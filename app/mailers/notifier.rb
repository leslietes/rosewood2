class Notifier < ApplicationMailer
  
  def contact_us(form)
    @name    = form[:name]
    @phone   = form[:phone]
    @mobile  = form[:mobile]
    @email   = form[:email]
    @message = form[:message]
    
    mail(to: "1ststopconveniencestore@gmail.com", subject: "Inquiry")
  end
end
