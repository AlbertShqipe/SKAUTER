class AddTimesToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :starts_at, :datetime
    add_column :bookings, :ends_at, :datetime
  end
end
