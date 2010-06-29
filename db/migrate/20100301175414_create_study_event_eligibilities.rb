class CreateStudyEventEligibilities < ActiveRecord::Migration
	def self.up
		create_table :study_event_eligibilities do |t|
			t.integer :position
			t.references :subject
			t.references :project
			t.string :eligibility_criterion
			t.string :criterion_response
			t.timestamps
		end
	end

	def self.down
		drop_table :study_event_eligibilities
	end
end
