class RegionsController < ApplicationController
  def show
    slug = params[:slug]

    # Find the real city by matching the slug
    cities = Location.where(available: true).distinct.pluck(:city)
    @city = cities.find { |c| c.to_s.parameterize == slug }

    return redirect_to(regions_path, alert: "Region not found") unless @city

    @locations = Location.where(city: @city, available: true).order(created_at: :desc)
  end

  def index
    @regions = Location.where(available: true).distinct.pluck(:city).sort
  end
end
