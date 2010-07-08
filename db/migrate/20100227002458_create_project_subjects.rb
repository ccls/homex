class CreateProjectSubjects < ActiveRecord::Migration
	def self.up
		create_table :project_subjects do |t|
			t.integer :position
			t.references :subject
			t.references :project
			t.references :ineligible_reason
			t.references :refusal_reason
			t.boolean :is_eligible
			t.boolean :is_chosen
			t.boolean :is_candidate
			t.string :reason_not_chosen
			t.string :recruitment_priority
			t.date :completed_on
			t.boolean :consented
			t.date :consented_on
			t.string :other_refusal_reason
			t.boolean :subject_terminated_participation
			t.string :subject_terminated_reason
			t.boolean :is_closed
			t.string :reason_closed
			t.text :enrollment_notes
			t.boolean :able_to_locate
			t.timestamps
		end
		add_index :project_subjects, [:project_id, :subject_id],
			:unique => true
	end

	def self.down
		drop_table :project_subjects
	end
end
