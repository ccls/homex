class CreateSubjectTypes < ActiveRecord::Migration
	def self.up
		create_table :subject_types do |t|
			t.string :description
			t.string :related_case_control_type
			t.timestamps
		end
	end

	def self.down
		drop_table :subject_types
	end
end
