class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  has_many :favorites, dependent: :destroy
  has_many :favorite_locations, through: :favorites, source: :location

  has_many :bookings, dependent: :destroy

  validates :first_name, :last_name, :address, :phone_number,
            presence: true,
            on: :create,
            unless: :admin?

  # optional helper
  def full_name
    [first_name, last_name].compact.join(" ")
  end
end
