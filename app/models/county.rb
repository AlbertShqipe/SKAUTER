class County < ApplicationRecord
  has_many :locations

  has_one_attached :cover_image

  validates :name, presence: true, uniqueness: true
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug, on: %i[create update]

  validates :latitude, :longitude, presence: true

  # ⛔ Prevent deletion at model level
  before_destroy :prevent_destroy

  private

  def set_slug
    self.slug = name.to_s.parameterize if name_changed?
  end

  def prevent_destroy
    errors.add(:base, "Counties cannot be deleted")
    throw(:abort)
  end
end
