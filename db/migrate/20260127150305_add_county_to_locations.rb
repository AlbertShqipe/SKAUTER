class AddCountyToLocations < ActiveRecord::Migration[7.1]
  def change
    add_reference :locations, :county, type: :uuid, foreign_key: true, index: true
  end
end
