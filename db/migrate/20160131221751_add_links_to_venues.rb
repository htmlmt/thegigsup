class AddLinksToVenues < ActiveRecord::Migration
    def change
        add_column :venues, :links, :string, array:true, default: []
    end
end
