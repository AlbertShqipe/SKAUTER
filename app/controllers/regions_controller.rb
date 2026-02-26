class RegionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    # --- FILTER PARAMS ---
    activity      = params[:activity]
    location_type = params[:location_type]
    date          = params[:start_date] # placeholder

    # --- BASE LOCATIONS SCOPE ---
    locations_scope = Location.where(available: true)

    # Activity
    if params[:activity].present?
      locations_scope = locations_scope.where(
        "? = ANY(activity_types)",
        params[:activity]
      )
    end

    # Text search
    if params[:q].present?
      locations_scope = locations_scope
        .search_by_text(params[:q])
        .reorder(nil) # 🔥 critical
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

    if params[:start_date].present? && params[:end_date].present?
      start_date = Time.zone.parse(params[:start_date])
      end_date   = Time.zone.parse(params[:end_date]).end_of_day

      locations_scope = locations_scope.where.not(
        id: Booking
          .where(status: [:pending, :approved])
          .where("starts_at < ? AND ends_at > ?", end_date, start_date)
          .select(:location_id)
      )
    end

    # --- DATA ---
    @locations = locations_scope.includes(:county)

    @counties = County
      .joins(:locations)
      .where(locations: { id: locations_scope.select(:id) })
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
    @locations = @county.locations
  end
end
