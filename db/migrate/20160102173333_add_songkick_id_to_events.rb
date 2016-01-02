class AddSongkickIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :songkick_id, :integer
  end
end
