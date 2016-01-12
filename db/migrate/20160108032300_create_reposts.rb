class CreateReposts < ActiveRecord::Migration
  def change
    create_table :reposts do |t|
      t.integer :event_id

      t.timestamps null: false
    end
  end
end
