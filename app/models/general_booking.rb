# app/models/general_booking.rb
class GeneralBooking < ApplicationRecord
  belongs_to :location
  belongs_to :user, optional: true

  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :name, :email, :starts_at, :ends_at, presence: true
  validate :ends_after_start

  after_create_commit :notify_admin

  private

  def ends_after_start
    return if starts_at.blank? || ends_at.blank?
    errors.add(:ends_at, "must be after start") if ends_at <= starts_at
  end

  def notify_admin
    GeneralBookingMailer.new_request(self).deliver_later
  end
end
