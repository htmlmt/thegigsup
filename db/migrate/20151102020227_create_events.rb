class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :facebook_id, :limit => 8

      t.timestamps null: false
    end
  end
end