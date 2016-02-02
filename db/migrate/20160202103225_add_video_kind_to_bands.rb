class AddVideoKindToBands < ActiveRecord::Migration
  def change
    add_column :bands, :video_kind, :string
  end
end
