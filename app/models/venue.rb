class Venue < ApplicationRecord
  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :full_name, :email, :phone, :city, :property_type, presence: true
  validates :terms_accepted, acceptance: true
end
