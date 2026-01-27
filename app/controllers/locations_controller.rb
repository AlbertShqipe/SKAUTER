class LocationsController < ApplicationController
  def index
    @locations = Location.all.order(created_at: :asc)
  end

  def show
    @location = Location.find(params[:id])
  end
end
