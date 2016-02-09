class AddSupportingActsToEvents < ActiveRecord::Migration
    def change
        add_column :events, :supporting_acts, :integer, array:true, default: []
    end
end
