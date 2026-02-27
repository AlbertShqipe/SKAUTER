class VenueMailer < ApplicationMailer
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

  def approved(venue)
    @venue = venue
    mail(to: @venue.email, subject: "Your venue has been approved")
  end

  def rejected(venue)
    @venue = venue
    mail(to: @venue.email, subject: "Your venue submission")
  end
end
