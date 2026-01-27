class CreateCounties < ActiveRecord::Migration[7.1]
  def change
    create_table :counties, id: :uuid do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.text :description

      t.timestamps
    end

    add_index :counties, :name, unique: true
    add_index :counties, :slug, unique: true
  end
end
