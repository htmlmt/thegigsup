class AddSongkickIdToVenues < ActiveRecord::Migration
  def change
    add_column :venues, :songkick_id, :integer
  end
end
