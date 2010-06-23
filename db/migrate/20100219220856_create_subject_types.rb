class CreateSubjectTypes < ActiveRecord::Migration
	def self.up
		create_table :subject_types do |t|
			t.integer :position
			t.string :description	#	, :limit => 1
			t.string :related_case_control_type
			t.timestamps
		end
		add_index :subject_types, :description, :unique => true
	end

	def self.down
		drop_table :subject_types
	end
end
