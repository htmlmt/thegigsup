class CreateBandsEventsJoinTable < ActiveRecord::Migration
    def self.up
        create_table :bands_events, :id => false do |t|
            t.integer :band_id
            t.integer :event_id
        end

        add_index :bands_events, [:band_id, :event_id]
    end

    def self.down
        drop_table :bands_events
    end
end
