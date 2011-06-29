class DropResponseSets < ActiveRecord::Migration
	def self.up
		drop_table :response_sets
	end

	def self.down
		create_table :response_sets do |t|
			# Context
			#	This is the current_user that started the survey.
			t.integer :user_id		
			t.integer :survey_id
#			t.integer :childid
			t.integer :study_subject_id

			# Content
			t.string :access_code #unique id for the object used in urls

			# Expiry
			t.datetime :started_at
			t.datetime :completed_at

			t.timestamps
		end
		add_index :response_sets, :access_code, :unique => true
		add_index :response_sets, :access_code, :unique => true, :name => 'response_sets_ac_idx'
		add_index :response_sets, :study_subject_id
	end
end
