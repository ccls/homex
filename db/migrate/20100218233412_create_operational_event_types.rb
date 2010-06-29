class CreateOperationalEventTypes < ActiveRecord::Migration
	def self.up
		create_table :operational_event_types do |t|
			t.integer :position
			t.references :project
			t.references :interview_event
			t.string :description
			t.timestamps
		end
		add_index :operational_event_types, :description, :unique => true
	end

	def self.down
		drop_table :operational_event_types
	end
end
