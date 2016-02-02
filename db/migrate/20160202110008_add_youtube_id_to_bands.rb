class AddYoutubeIdToBands < ActiveRecord::Migration
  def change
    add_column :bands, :youtube_id, :string
  end
end
