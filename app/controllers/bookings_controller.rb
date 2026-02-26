class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_location

  def availability
    starts_at = parse_dt(params[:starts_at])
    ends_at   = parse_dt(params[:ends_at])

    available = @location.available_for?(starts_at, ends_at)

    render json: { available: available }
  end

  def new
    @booking = @location.bookings.new
  end

  def create
    @booking = @location.bookings.new(booking_params)
    @booking.user = current_user
    @booking.status = :pending

    if @booking.save
      redirect_to location_path(@location), notice: "Booking request sent. Waiting for approval."
    else
      redirect_to location_path(@location), alert: @booking.errors.full_messages.to_sentence
    end
  end

  private

  def set_location
    @location = Location.find(params[:location_id])
  end

  def booking_params
    params.require(:booking).permit(:booking_type, :starts_at, :ends_at)
  end

  def parse_dt(value)
    return if value.blank?
    Time.zone.parse(value) rescue nil
  end

end
