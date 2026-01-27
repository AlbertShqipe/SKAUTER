class RegionsController < ApplicationController
  def show
    @county = County.find_by!(slug: params[:slug])
    @locations = @county.locations.where(available: true)
  end

  def index
    @regions = Location.all
    @distinct_cities = Location.where(available: true).distinct.pluck(:city).sort
    @distinct_counties = Location.where(available: true).distinct.pluck(:county).sort

  end
end
