class Location < ApplicationRecord
  belongs_to :county

  has_one_attached :cover_image
  has_many_attached :images

  has_many :favorites, dependent: :destroy
  has_many :favorited_by, through: :favorites, source: :user

  # Validations
  validates :name, presence: true
  validates :city, presence: true
  validates :county, presence: true
  validates :location_type, presence: true

  validates :price_per_hour, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price_per_day, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :capacity, numericality: { greater_than: 0 }, allow_nil: true

  attribute :available, :boolean, default: true

  # Scopes
  scope :available, -> { where(available: true) }
  scope :verified_hosts, -> { where(host_verified: true) }
  scope :by_city, ->(city) { where(city: city) }
  scope :by_county, ->(county) { where(county: county) }

  TAGS = [
    "albanian",
    "architecture",
    "art",
    "authentic",
    "beach",
    "castle",
    "coastal",
    "communist era",
    "cultural",
    "educational",
    "events",
    "garden",
    "historic",
    "industrial",
    "luxury",
    "medieval",
    "modern",
    "monument",
    "nature",
    "ottoman",
    "outdoor",
    "park",
    "populated",
    "religious",
    "residential",
    "rural",
    "scenic",
    "spacious",
    "sports",
    "unique",
    "urban",
    "water"
  ].freeze

  LOCATION_TYPE_RULES = {
    "Villas & Estates" => /villa|estate|unique/i,
    "Hotels & Guesthouses" => /hotel|guesthouse|resort/i,
    "Historic & Cultural" => /historic|castle|cultural|religious/i,
    "Urban & Public Spaces" => /square|market|bazaar|bridge/i,
    "Nature & Outdoor" => /park|garden|lake|waterfront|nature/i,
    "Industrial & Modern" => /industrial|sports|factory/i
  }.freeze

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

  def self.unique_location_types
    distinct
      .pluck(:location_type)
      .compact
      .map(&:strip)
      .map(&:downcase)
      .uniq
      .sort
  end

  def self.dynamic_location_type_groups
    groups = Hash.new { |h, k| h[k] = [] }

    unique_location_types.each do |type|
      matched = false

      LOCATION_TYPE_RULES.each do |group, regex|
        if type.match?(regex)
          groups[group] << type
          matched = true
          break
        end
      end

      # Fallback: uncategorized but NOT lost
      groups["Other"] << type unless matched
    end

    groups
  end

  private

  def normalize_arrays
    self.tags = tags.split(",").map(&:strip) if tags.is_a?(String)
    self.amenities = amenities.split(",").map(&:strip) if amenities.is_a?(String)
  end

end
