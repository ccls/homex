class CreateResponseSets < ActiveRecord::Migration
	def self.up
		table_name = 'response_sets'
		create_table table_name do |t|
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
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		#	Jake added this because it seems necessary.
		#	Despite the above statement "unique id ...", without
		#	this index, there is no guarantee that it is unique.
		add_index( table_name, :access_code, :unique => true
			) unless idxs.include?("index_#{table_name}_on_access_code")
		#	NOT unique
#		add_index :response_sets, :childid
		add_index( table_name, :study_subject_id
			) unless idxs.include?("index_#{table_name}_on_study_subject_id")
	end

	def self.down
		drop_table :response_sets
	end
end
