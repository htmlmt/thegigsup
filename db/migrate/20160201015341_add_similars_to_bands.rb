class AddSimilarsToBands < ActiveRecord::Migration
    def change
        add_column :bands, :similars, :integer, array:true, default: []
    end
end
