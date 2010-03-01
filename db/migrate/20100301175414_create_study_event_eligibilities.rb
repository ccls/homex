class CreateStudyEventEligibilities < ActiveRecord::Migration
	def self.up
		create_table :study_event_eligibilities do |t|
			t.references :subject
			t.references :study_event
			t.string :eligibility_criterion
			t.string :criterion_response
			t.timestamps
		end
	end

	def self.down
		drop_table :study_event_eligibilities
	end
end
