class GeneralBookingMailer < ApplicationMailer
  def new_request(booking)
    @booking = booking
    @location = booking.location

    mail(
      to: "admin@skauter.al",
      subject: "New Booking Enquiry – #{@location.name}"
    )
  end
end
