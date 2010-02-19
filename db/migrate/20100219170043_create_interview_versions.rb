class CreateInterviewVersions < ActiveRecord::Migration
	def self.up
		create_table :interview_versions do |t|
			t.references :interview_type
			t.references :interview_event
			t.date :began_use_on
			t.date :ended_use_on
			t.string :description
			t.timestamps
		end
	end

	def self.down
		drop_table :interview_versions
	end
end
