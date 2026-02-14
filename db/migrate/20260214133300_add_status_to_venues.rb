class AddStatusToVenues < ActiveRecord::Migration[7.1]
  def change
    add_column :venues, :status, :integer
  end
end
