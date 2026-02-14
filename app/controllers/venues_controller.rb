class VenuesController < ApplicationController
  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    @venue.status = :pending

    if @venue.save
      VenueMailer.new_submission(@venue).deliver_later
      VenueMailer.confirmation(@venue).deliver_later

      redirect_to root_path,
        notice: "Your venue has been submitted successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def venue_params
    params.require(:venue).permit(
      :full_name,
      :email,
      :phone,
      :city,
      :property_type,
      :terms_accepted
    )
  end
end
