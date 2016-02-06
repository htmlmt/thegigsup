class AddHeadlinerToEvents < ActiveRecord::Migration
  def change
    add_column :events, :headliner, :integer
  end
end
