class AddPosterToEvents < ActiveRecord::Migration
    def self.up
        add_attachment :events, :poster
    end

    def self.down
        remove_attachment :events, :poster
    end
end
