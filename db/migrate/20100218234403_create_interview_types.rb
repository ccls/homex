class CreateInterviewTypes < ActiveRecord::Migration
	def self.up
		create_table :interview_types do |t|
			t.references :study_event
			t.string :description
			t.timestamps
		end
	end

	def self.down
		drop_table :interview_types
	end
end
