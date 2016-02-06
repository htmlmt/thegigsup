class AddHeadlinerToBands < ActiveRecord::Migration
  def change
    add_column :bands, :headliner, :boolean
  end
end
