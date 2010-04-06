class CreateSubjects < ActiveRecord::Migration
	def self.up
		create_table :subjects do |t|
#			t.integer :position
			t.references :subject_type
			t.references :race
#			t.references :operational_event
#			t.references :ineligible_reason
#			t.references :refusal_reason
#			t.string     :other_refusal_reason
			t.date :referenced_on
			t.boolean :is_hispanic
			t.integer :response_sets_count, :default => 0
			t.timestamps
		end
	end

	def self.down
		drop_table :subjects
	end
end
