class VenueMailer < ApplicationMailer
  default from: "no-reply@skauter.al"

  def new_submission(venue)
    @venue = venue

    mail(
      to: "admin@skauter.al",
      subject: "New Venue Submission – #{venue.full_name}"
    )
  end

  def confirmation(venue)
    @venue = venue

    mail(
      to: venue.email,
      subject: "We received your venue submission"
    )
  end
end
