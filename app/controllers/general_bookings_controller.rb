class GeneralBookingsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    @location = Location.find(params[:location_id])
    @general_booking = @location.general_bookings.new
  end

  def create
    @location = Location.find(params[:location_id])
    @general_booking = @location.general_bookings.new(general_booking_params)
    @general_booking.user = current_user if user_signed_in?

    if @general_booking.save
      redirect_to location_path(@location),
        notice: "Your request has been sent! We'll be in touch soon."
    else
      redirect_to location_path(@location),
        alert: "Something went wrong. Please try again."
    end
  end

  private

  def general_booking_params
    params.require(:general_booking).permit(
      :name, :email, :phone, :company,
      :activity_type, :crew_size, :project_name,
      :starts_at, :ends_at, :notes
    )
  end
end
