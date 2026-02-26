class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings, id: :uuid, default: -> { "gen_random_uuid()" } do |t|
      t.references :user, null: false, foreign_key: true # users is bigint id
      t.references :location, null: false, type: :uuid, foreign_key: true

      t.integer :booking_type, null: false # 0 hourly, 1 daily
      t.integer :status, null: false, default: 0 # 0 pending, 1 approved, 2 rejected

      t.integer :hours
      t.integer :days
      t.integer :total_price

      t.timestamps
    end

    add_index :bookings, [:location_id, :status]
  end
end
