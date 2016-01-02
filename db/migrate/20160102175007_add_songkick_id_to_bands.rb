class AddSongkickIdToBands < ActiveRecord::Migration
  def change
    add_column :bands, :songkick_id, :integer
  end
end
