class ContactMailer < ApplicationMailer
  def new_message(name, email, message)
    @name    = name
    @email   = email
    @message = message

    mail(
      to:       "admin@skauter.al",
      reply_to: email,
      subject:  "New Contact Message from #{name}"
    )
  end
end
