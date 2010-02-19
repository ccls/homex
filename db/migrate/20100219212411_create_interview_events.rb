class CreateInterviewEvents < ActiveRecord::Migration
	def self.up
		create_table :interview_events do |t|
			t.references :subject
			t.references :address
			t.references :interviewer
			t.references :interview_version
			t.date :began_on
			t.date :ended_on
			t.string :language
			t.string :respondent_first_name
			t.string :respondent_last_name
			t.integer :respondent_relationship_id
			t.string :respondent_relationship_other
			t.timestamps
		end
	end

	def self.down
		drop_table :interview_events
	end
end
