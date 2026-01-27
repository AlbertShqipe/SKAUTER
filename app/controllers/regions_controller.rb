class RegionsController < ApplicationController
  def index
    @counties = County
      .joins(:locations)
      .where(locations: { available: true })
      .distinct
      .order(:name)
  end

  def show
    @county = County.find_by!(slug: params[:slug])
    @locations = @county.locations.where(available: true)
  end
end
