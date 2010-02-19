class CreateInterviewers < ActiveRecord::Migration
	def self.up
		create_table :interviewers do |t|
			t.references :context
			t.string :first_name
			t.string :last_name
			t.timestamps
		end
	end

	def self.down
		drop_table :interviewers
	end
end
