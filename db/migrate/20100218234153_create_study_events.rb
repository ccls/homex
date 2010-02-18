class CreateStudyEvents < ActiveRecord::Migration
	def self.up
		create_table :study_events do |t|
			t.date :began_on
			t.date :ended_on
			t.string :description
			t.timestamps
		end
	end

	def self.down
		drop_table :study_events
	end
end
