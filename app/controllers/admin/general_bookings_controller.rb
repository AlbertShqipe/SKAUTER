class Admin::GeneralBookingsController < ApplicationController
  before_action :require_admin
  before_action :set_booking, only: [:show, :update]

  def index
    @bookings = GeneralBooking.includes(:user, :location)
                              .order(created_at: :desc)
  end

  def show
  end

  def update
    @booking.update!(status: params[:status])
    redirect_to admin_general_bookings_path, notice: "Booking updated"
  end

  private

  def set_booking
    @booking = GeneralBooking.find(params[:id])
  end

  def require_admin
    redirect_to root_path unless current_user&.role == "admin"
  end
end
