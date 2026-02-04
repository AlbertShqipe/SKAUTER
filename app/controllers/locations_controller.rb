class LocationsController < ApplicationController
  def index
    @locations = Location.all.order(created_at: :asc)

    if params[:location_type].present?
      @locations = @locations.where(location_type: params[:location_type])
    end

    if params[:activity].present?
      @locations = @locations.where("? = ANY(tags)", params[:activity])
    end

    if params[:date].present?
      # Placeholder for future availability logic
    end
  end

  def show
    @location = Location.find(params[:id])
  end
end
