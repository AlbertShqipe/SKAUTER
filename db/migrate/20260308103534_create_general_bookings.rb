class CreateGeneralBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :general_bookings, id: :uuid do |t|
      t.references :location, null: false, foreign_key: true, type: :uuid
      t.references :user, null: true, foreign_key: true, type: :bigint  # ← match users.id type

      t.string :name,          null: false
      t.string :email,         null: false
      t.string :phone
      t.string :company
      t.string :activity_type
      t.string :crew_size
      t.string :project_name
      t.datetime :starts_at
      t.datetime :ends_at
      t.text :notes
      t.integer :status,       default: 0, null: false
      t.text :admin_notes

      t.timestamps
    end
  end
end
