class CreateImports < ActiveRecord::Migration
	def self.up
		create_table :imports do |t|
			t.date :dob
			t.date :diagnosis_date
			t.string :first_name
			t.string :middle_name
			t.string :last_name
			t.string :sex
			t.integer :language_id
			t.boolean :is_hispanic
			t.string :race
			t.string :phone_primary
			t.string :phone_alternate
#			t.date :date_dust_kit_sent
			t.date :dust_kit_sent_on
#			t.date :interview_complete_date
			t.date :completed_interview_on
#			t.date :date_case_assigned_to_interviewer
			t.date :case_assigned_on
			t.string :respondent_type
			t.string :respondent_first_name
			t.string :respondent_middle_name
			t.string :respondent_last_name
#			t.date :date_of_last_action
			t.date :last_action_on
			t.string :respondent_address_line_1
			t.string :respondent_address_line_2
			t.string :respondent_city
			t.string :respondent_state
			t.string :respondent_zip

			t.timestamps
		end
	end

	def self.down
		drop_table :imports
	end
end
