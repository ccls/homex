class DropSurveyInvitations < ActiveRecord::Migration
	def self.up
		drop_table :survey_invitations
	end

	def self.down
		create_table :survey_invitations do |t|
			t.integer :study_subject_id, :null => false
			t.references :response_set
			t.references :survey
			t.string :token, :null => false
			t.datetime :sent_at
			t.timestamps
		end
		add_index :survey_invitations, :token, :unique => true
		add_index :survey_invitations, [:survey_id, :study_subject_id], :unique => true
	end
end
