class Admin::VenuesController < Admin::BaseController
  before_action :set_venue, only: [:show, :update]

  def index
    @venues = Venue.order(created_at: :desc)
  end

  def show
  end

  def update
    if @venue.update(status: params[:status])
      if @venue.approved?
        VenueMailer.approved(@venue).deliver_later
      elsif @venue.rejected?
        VenueMailer.rejected(@venue).deliver_later
      end

      redirect_to admin_venues_path,
        notice: "Venue updated successfully."
    end
  end

  private

  def set_venue
    @venue = Venue.find(params[:id])
  end
end
