class CreateLocations < ActiveRecord::Migration[7.1]
  def change
    enable_extension "pgcrypto" unless extension_enabled?("pgcrypto")

    create_table :locations, id: :uuid do |t|
      t.string  :name, null: false
      t.text    :description
      t.string  :location_type
      t.string  :city
      t.string  :county
      t.string  :address

      t.decimal :latitude, precision: 10, scale: 6
      t.decimal :longitude, precision: 10, scale: 6

      t.integer :price_per_hour
      t.integer :price_per_day
      t.integer :capacity

      t.string  :cover_image
      t.boolean :available, default: true

      t.string  :host_name
      t.boolean :host_verified, default: false

      # PostgreSQL arrays
      t.string :tags, array: true, default: []
      t.string :amenities, array: true, default: []
      t.string :images, array: true, default: []

      t.timestamps
    end

    add_index :locations, :city
    add_index :locations, :county
    add_index :locations, :location_type
    add_index :locations, :tags, using: "gin"
    add_index :locations, :amenities, using: "gin"
  end
end
