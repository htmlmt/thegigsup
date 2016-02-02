class AddTicketLinkToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ticket_link, :string
  end
end
