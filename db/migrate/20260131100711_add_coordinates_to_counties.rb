class AddCoordinatesToCounties < ActiveRecord::Migration[7.1]
  def change
    add_column :counties, :latitude, :float
    add_column :counties, :longitude, :float
  end
end
