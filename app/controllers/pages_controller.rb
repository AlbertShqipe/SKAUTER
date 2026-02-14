class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @counties = County
      .left_joins(:locations)
      # .where(locations: { available: true })
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
end
