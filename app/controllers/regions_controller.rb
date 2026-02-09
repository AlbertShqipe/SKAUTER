class RegionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # --- FILTER PARAMS ---
    activity      = params[:activity]
    location_type = params[:location_type]
    date          = params[:date] # placeholder

    # --- BASE LOCATIONS SCOPE ---
    locations_scope = Location.where(available: true)

    # Activity
    if params[:activity].present?
      locations_scope = locations_scope.where(
        "? = ANY(activity_types)",
        params[:activity]
      )
    end

    if params[:q].present?
      locations_scope = locations_scope.search(params[:q])
    end

    # County
    if params[:county_id].present?
      locations_scope = locations_scope.where(county_id: params[:county_id])
    end

    # Exact type
    if params[:location_type].present?
      locations_scope = locations_scope.where(
        "LOWER(location_type) = ?",
        params[:location_type].downcase
      )
    end

    # Grouped type
    if params[:type].present?
      rule = Location::LOCATION_TYPE_RULES[params[:type]]
      locations_scope = locations_scope.where("location_type ~* ?", rule.source) if rule
    end

    # --- DATA ---
    @locations = locations_scope.includes(:county)

    @counties = County
      .joins(:locations)
      .merge(locations_scope)
      .distinct
      .order(:name)

    @types = Location::LOCATION_TYPE_RULES.keys

    @markers = @locations.map do |l|
      {
        id: l.id,
        name: l.name,
        lat: l.latitude,
        lng: l.longitude,
        county: { name: l.county.name }
      }
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @county = County.find_by!(slug: params[:slug])
    @locations = @county.locations.where(available: true)
  end
end
