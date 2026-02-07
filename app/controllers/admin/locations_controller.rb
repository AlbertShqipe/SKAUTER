class Admin::LocationsController < Admin::BaseController
  before_action :set_location, only: %i[edit update destroy show]
  before_action :normalize_arrays, only: %i[create update]

  def index
    @locations = Location.all.order(created_at: :asc)
  end

  def show
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params.except(:cover_image, :images))

    if @location.save
      attach_images
      redirect_to admin_locations_path, notice: "Location created"
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @location.update(location_params.except(:cover_image, :images))
      attach_images
      redirect_to admin_locations_path, notice: "Location updated"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def edit; end


  def destroy
    @location.destroy
    redirect_to admin_locations_path, notice: "Location deleted"
  end

  private

  def set_location
    @location = Location.find(params[:id])
  end

  def location_params
    params.require(:location).permit(
      :name,
      :description,
      :city,
      :county,
      :address,
      :location_type,
      :price_per_hour,
      :price_per_day,
      :capacity,
      :available,
      :host_name,
      :host_verified,
      :cover_image,
      :county_id,
      tags: [],
      amenities: [],
      images: [],
      activity_types: []
    )
  end

  def attach_images
    # Replace cover image
    if params[:location][:cover_image].present?
      @location.cover_image.purge if @location.cover_image.attached?
      @location.cover_image.attach(params[:location][:cover_image])
    end

    # Replace gallery images
    if params[:location][:images].present?
      # Remove empty file inputs
      images = params[:location][:images].reject(&:blank?)

      if images.any?
        @location.images.purge
        images.each do |image|
          @location.images.attach(image)
        end
      end
    end
  end

  def normalize_arrays
    %i[tags amenities activity_types].each do |field|
      if params[:location][field].is_a?(String)
        params[:location][field] = params[:location][field]
          .split(",")
          .map(&:strip)
          .reject(&:blank?)
      end
    end
  end
end
