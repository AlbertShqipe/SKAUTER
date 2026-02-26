class Admin::BookingsController < Admin::BaseController
  before_action :set_booking, only: %i[show update]

  def index
    @bookings = Booking.includes(:user, :location).order(created_at: :desc)
  end

  def show; end

  def update
    @booking.update!(status: params[:status])

    # If approved → location unavailable
    # if @booking.approved?
    #   @booking.location.update!(available: false)
    # end

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to admin_bookings_path, notice: "Booking updated" }
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end
end
