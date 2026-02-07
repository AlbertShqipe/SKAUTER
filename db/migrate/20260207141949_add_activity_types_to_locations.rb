class AddActivityTypesToLocations < ActiveRecord::Migration[7.1]
  def change
    add_column :locations, :activity_types, :string, array: true, default: []
    add_index  :locations, :activity_types, using: "gin"
  end
end
