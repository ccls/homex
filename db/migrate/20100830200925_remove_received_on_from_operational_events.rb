class RemoveReceivedOnFromOperationalEvents < ActiveRecord::Migration
	def self.up
		remove_column :operational_events, :received_on
	end

	def self.down
		add_column :operational_events, :received_on, :date
	end
end
