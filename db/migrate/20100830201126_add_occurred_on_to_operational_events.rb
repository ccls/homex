class AddOccurredOnToOperationalEvents < ActiveRecord::Migration
	def self.up
		add_column :operational_events, :occurred_on, :date
	end

	def self.down
		remove_column :operational_events, :occurred_on
	end
end
