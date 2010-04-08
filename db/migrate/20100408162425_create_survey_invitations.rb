class CreateSurveyInvitations < ActiveRecord::Migration
	def self.up
		create_table :survey_invitations do |t|
			t.references :subject, :null => false
			t.references :response_set
			t.string :token, :null => false
			t.timestamps
		end
		add_index :survey_invitations, :token, :unique => true
	end

	def self.down
		drop_table :survey_invitations
	end
end
