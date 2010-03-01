class CreateSubjects < ActiveRecord::Migration
	def self.up
		create_table :subjects do |t|
			t.references :subject_type
			t.references :race
			t.date :referenced_on
			t.boolean :is_hispanic
			t.timestamps
		end
	end

	def self.down
		drop_table :subjects
	end
end
