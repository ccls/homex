class CreateOperationalEventTypes < ActiveRecord::Migration
	def self.up
		create_table :operational_event_types do |t|
			t.references :study_event
			t.string :description
			t.timestamps
		end
	end

	def self.down
		drop_table :operational_event_types
	end
end
