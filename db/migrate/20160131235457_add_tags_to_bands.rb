class AddTagsToBands < ActiveRecord::Migration
    def change
        add_column :bands, :tags, :string, array:true, default: []
    end
end
