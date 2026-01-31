class RegionsController < ApplicationController
  def index
    @counties = County
      .joins(:locations)
      .where(locations: { available: true })
      .distinct
      .order(:name)

    @county_markers = @counties.map do |c|
      {
        id: c.id,
        name: c.name,
        lat: c.latitude,
        lng: c.longitude
      }
    end

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

    @selected_county = County.find_by(slug: params[:county]) if params[:county].present?
  end

  def show
    @county = County.find_by!(slug: params[:slug])
    @locations = @county.locations.where(available: true)
  end
end
