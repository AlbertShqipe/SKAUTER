# Preview all emails at http://localhost:3000/rails/mailers/general_booking_mailer
class GeneralBookingMailerPreview < ActionMailer::Preview
  def new_request
    GeneralBookingMailer.new_request(GeneralBooking.first)
  end
end
