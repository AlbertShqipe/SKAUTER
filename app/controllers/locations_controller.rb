class LocationsController < ApplicationController
  def index
    @locations = Location.where(available: true)
  end

  def show
    @location = Location.find(params[:id])
  end
end
