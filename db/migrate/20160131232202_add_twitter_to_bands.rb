class AddTwitterToBands < ActiveRecord::Migration
  def change
    add_column :bands, :twitter, :string
  end
end
