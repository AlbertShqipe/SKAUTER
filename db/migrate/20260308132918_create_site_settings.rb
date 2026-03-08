class CreateSiteSettings < ActiveRecord::Migration[7.1]
  def change
    create_table :site_settings, id: :uuid do |t|
      t.string :key
      t.boolean :value

      t.timestamps
    end
  end
end
