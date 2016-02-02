class AddSongkickLinkToEvents < ActiveRecord::Migration
  def change
    add_column :events, :songkick_link, :string
  end
end
