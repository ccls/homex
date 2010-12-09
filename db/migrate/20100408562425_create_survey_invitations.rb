class CreateSurveyInvitations < ActiveRecord::Migration
	def self.up
		table_name = 'survey_invitations'
		create_table table_name do |t|
			t.integer :study_subject_id, :null => false
			t.references :response_set
			t.references :survey
			t.string :token, :null => false
			t.datetime :sent_at
			t.timestamps
		end unless table_exists?(table_name)
		idxs = indexes(table_name).map(&:name)
		add_index( table_name, :token, :unique => true
			) unless idxs.include?("index_#{table_name}_on_token")
		add_index( table_name, [:survey_id, :study_subject_id], :unique => true
			) unless idxs.include?("index_#{table_name}_on_survey_id_and_study_subject_id")
	end

	def self.down
		drop_table :survey_invitations
	end
end
