class CreateInterviewVersions < ActiveRecord::Migration
	def self.up
		create_table :interview_versions do |t|
			t.integer :position
			t.references :interview_type
			t.references :interview_event
			t.date :began_use_on
			t.date :ended_use_on
			t.string :description
			t.timestamps
		end
		add_index :interview_versions, :description, :unique => true
	end

	def self.down
		drop_table :interview_versions
	end
end
