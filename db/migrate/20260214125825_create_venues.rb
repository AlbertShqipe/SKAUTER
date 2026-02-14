class CreateVenues < ActiveRecord::Migration[7.1]
  def change
    create_table :venues, id: :uuid do |t|
      t.string :full_name
      t.string :email
      t.string :phone
      t.string :city
      t.string :property_type
      t.boolean :terms_accepted

      t.timestamps
    end
  end
end
