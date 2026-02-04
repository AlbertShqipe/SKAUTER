class RegionsController < ApplicationController
  def index
    # --- FILTER PARAMS ---
    activity      = params[:activity]
    location_type = params[:location_type]
    date          = params[:date] # placeholder for later

    # --- BASE LOCATIONS SCOPE ---
    locations_scope = Location.where(available: true)

    # # Filter by activity (using tags array)
    # if activity.present?
    #   locations_scope = locations_scope.where("? = ANY(tags)", activity)
    # end

    # Filter by location type
    if params[:location_type].present?
      locations_scope = locations_scope.where(
        "LOWER(location_type) = ?",
        params[:location_type].downcase
      )
    end

    # --- COUNTIES (ONLY THOSE WITH FILTERED LOCATIONS) ---
    @counties = County
      .joins(:locations)
      .merge(locations_scope)
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

    # --- LOCATIONS (FILTERED) ---
    @locations = locations_scope.includes(:county)

    @markers = @locations.map do |l|
      {
        id: l.id,
        name: l.name,
        county: l.county.name,
        lat: l.latitude,
        lng: l.longitude
      }
    end

    # --- SELECTED COUNTY (OPTIONAL ZOOM) ---
    @selected_county = County.find_by(slug: params[:county]) if params[:county].present?
  end

  def show
    @county = County.find_by!(slug: params[:slug])
    @locations = @county.locations.where(available: true)
  end
end
