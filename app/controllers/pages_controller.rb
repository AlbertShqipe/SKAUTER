class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :scouting, :services]

  def home
  end

  def scouting
    @counties = County
      .left_joins(:locations)
      .where(locations: { available: true })
      .group("counties.id")
      .select(
        "counties.*,
        COUNT(locations.id) AS locations_count"
      )

    @mapbox_api_key = ENV["MAPBOX_API_KEY"]
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

    @location_type_counts = {}

    Location::LOCATION_TYPE_RULES.each do |label, regex|
      @location_type_counts[label] =
        Location.where("location_type ILIKE ANY (ARRAY[?])",
          Location.pluck(:location_type)
            .select { |t| t&.match?(regex) }
        ).count
    end
  end

  def list_venue
  end

  def services
  end

  def contact
  end

  def send_message
    name    = params[:name]
    email   = params[:email]
    message = params[:message]

    if name.present? && email.present? && message.present?
      ContactMailer.new_message(name, email, message).deliver_later
      redirect_to contact_path, notice: "Message sent! We'll be in touch soon."
    else
      flash[:alert] = "Please fill in all fields."
      render :contact, status: :unprocessable_entity
    end
  end
end
