class AddHeadlinersToEvents < ActiveRecord::Migration
    def change
        add_column :events, :headliners, :integer, array:true, default: []
    end
end
