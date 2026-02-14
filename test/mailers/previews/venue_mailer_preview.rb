# Preview all emails at http://localhost:3000/rails/mailers/venue_mailer
class VenueMailerPreview < ActionMailer::Preview
  def approved
    VenueMailer.approved(Venue.first)
  end

  def rejected
    VenueMailer.rejected(Venue.second)
  end

  def confirmation
    VenueMailer.confirmation(Venue.first)
  end

  def new_submission
    VenueMailer.new_submission(Venue.first)
  end
end
