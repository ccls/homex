class CreateStudyEvents < ActiveRecord::Migration
	def self.up
		create_table :study_events do |t|
			t.integer :position
			t.date :began_on
			t.date :ended_on
			t.string :description
			t.timestamps
		end
		add_index :study_events, :description, :unique => true
	end

	def self.down
		drop_table :study_events
	end
end
