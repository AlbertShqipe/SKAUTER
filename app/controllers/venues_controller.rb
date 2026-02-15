class VenuesController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @venue = Venue.new
    @locations = Location.where(available: true)
    @markers = @locations.filter_map do |location|
      next unless location.latitude.present? && location.longitude.present?

      {
        id: location.id,
        name: location.name.to_s,
        lat: location.latitude.to_f,
        lng: location.longitude.to_f,
        county: {
          id: location.county.id,
          name: location.county.name,
          slug: location.county.slug
        }
      }
    end
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
