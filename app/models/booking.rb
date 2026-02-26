class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :location

  enum booking_type: { hourly: 0, daily: 1 }
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :booking_type, :status, :starts_at, :ends_at, presence: true
  validate :ends_after_start
  validate :location_must_be_available, on: :create
  validate :no_overlapping_booking, on: :create


  before_validation :normalize_times_for_daily
  before_validation :compute_duration_and_price

  after_update_commit :sync_location_availability, if: :saved_change_to_status?


  def compute_total_price
    return unless location

    self.total_price =
      if hourly?
        return unless starts_at && ends_at
        hours = ((ends_at - starts_at) / 1.hour).ceil
        hours = 1 if hours < 1
        hours * location.price_per_hour.to_i
      else
        return unless start_date && end_date
        days = (end_date - start_date).to_i + 1
        days = 1 if days < 1
        days * location.price_per_day.to_i
      end
  end

  private

  def no_overlapping_booking
    return if starts_at.blank? || ends_at.blank?

    overlap_exists = location.bookings
      .where(status: [:pending, :approved])
      .where.not(id: id)
      .where("starts_at < ? AND ends_at > ?", ends_at, starts_at)
      .exists?

    errors.add(:base, "This location is already booked for those dates/times.") if overlap_exists
  end

  def ends_after_start
    return if starts_at.blank? || ends_at.blank?
    errors.add(:ends_at, "must be after start time") if ends_at <= starts_at
  end

  def normalize_times_for_daily
    return unless daily?
    return if starts_at.blank? || ends_at.blank?

    # Make daily bookings cover full days (optional but nice)
    self.starts_at = starts_at.beginning_of_day
    self.ends_at   = ends_at.end_of_day
  end

  def compute_duration_and_price
    return if starts_at.blank? || ends_at.blank? || location.blank?

    if hourly?
      duration_hours = ((ends_at - starts_at) / 1.hour).ceil
      self.hours = [duration_hours, 1].max
      self.days  = nil
      self.total_price = location.price_per_hour.to_i * hours
    else
      # daily duration in days (inclusive-ish)
      duration_days = ((ends_at.to_date - starts_at.to_date).to_i + 1)
      self.days  = [duration_days, 1].max
      self.hours = nil
      self.total_price = location.price_per_day.to_i * days
    end
  end

  def location_must_be_available
    return if location&.available?
    errors.add(:base, "This location is no longer available.")
  end

  def sync_location_availability
    location.update!(available: !location.bookings.approved.exists?)
  end
end
