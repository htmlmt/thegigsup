class AddVideoLinkToBands < ActiveRecord::Migration
  def change
    add_column :bands, :video_link, :string
  end
end
