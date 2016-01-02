class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.string :name
      t.string :city
      t.string :street
      t.integer :zip
      t.string :website
      t.float :longitude
      t.float :latitude

      t.timestamps null: false
    end
  end
end
