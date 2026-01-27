class Location < ApplicationRecord
  has_one_attached :cover_image
  has_many_attached :images

  # Validations
  validates :name, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :location_type, presence: true

  validates :price_per_hour, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price_per_day, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :capacity, numericality: { greater_than: 0 }, allow_nil: true

  # Scopes
  scope :available, -> { where(available: true) }
  scope :verified_hosts, -> { where(host_verified: true) }
  scope :by_city, ->(city) { where(city: city) }
  scope :by_county, ->(county) { where(county: county) }

  after_initialize do
    self.tags ||= []
    self.amenities ||= []
  end

  def price_label
    return unless price_per_day || price_per_hour

    amount = price_per_day || price_per_hour
    unit   = price_per_day ? "day" : "hour"

    "#{amount} € / #{unit}"
  end

  def full_location
    [city, county].compact.join(", ")
  end

  private

  def normalize_arrays
    self.tags = tags.split(",").map(&:strip) if tags.is_a?(String)
    self.amenities = amenities.split(",").map(&:strip) if amenities.is_a?(String)
  end

end
