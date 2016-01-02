class AddEventIdToBands < ActiveRecord::Migration
  def change
    add_column :bands, :event_id, :integer
  end
end
