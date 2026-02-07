class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location, only: [:create, :destroy]

  def index
    @locations = current_user
                  .favorite_locations
                  .includes(:county, cover_image_attachment: :blob)

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

  def create
    current_user.favorites.create!(location: @location)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  def destroy
    current_user.favorites.find_by(location: @location)&.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_back fallback_location: root_path }
    end
  end

  private

  def set_location
    @location = Location.find(params[:location_id])
  end
end
