class RegionsController < ApplicationController
  def index
    @counties = County
      .joins(:locations)
      .where(locations: { available: true })
      .distinct
      .order(:name)

    @locations = Location.where(available: true)

    @markers = @locations.map do |l|
      {
        id: l.id,
        name: l.name,
        county: l.county.name,
        lat: l.latitude,
        lng: l.longitude
      }
    end
  end

  def show
    @county = County.find_by!(slug: params[:slug])
    @locations = @county.locations.where(available: true)
  end
end
